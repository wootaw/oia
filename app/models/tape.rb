class Tape < ApplicationRecord
  include AASM

  SCHEMAS = {}.tap do |schemas|
    Dir[File.join(Rails.root, 'public/schemas/**/schema.json')].each do |fn|
      m = /.*\/(v.*)\/schema\.json/.match(fn)
      schemas[m[1]] = fn unless m.nil?
    end
  end

  belongs_to :project

  enum state: {
    mounted:    10,
    broken:     25,
    invalided:  30,
    good:       60,
    finished:   90
  }

  aasm column: :state, enum: true do
    state :mounted, initial: true
    state :broken, :invalided, :good, :finished

    event :discard do
      transitions from: :mounted, to: :broken
    end

    event :invalidate do
      transitions from: :mounted, to: :invalided
    end

    event :pass do
      transitions from: :mounted, to: :good
    end

    event :apply do
      transitions from: :good, to: :finished
    end
  end

  def data
    if self.broken? || self.invalided?
      nil
    else
      begin
        @result ||= JSON.parse(self.content)
        if self.mounted?
          self.class::SCHEMAS.each do |v, fn|
            if JSON::Validator.validate(fn, @result)
              self.schema = v
              self.pass
              return @result
            end
          end
          self.invalidate!
          return nil
        end
        @result
      rescue JSON::ParserError => e
        self.discard!
        nil
      end
    end
  end

  def self.transcription(project_id)
    project = Project.find_by(id: project_id)
    unless project.nil?
      tapes = project.tapes.where(state: [:mounted, :good]).order(:created_at)
      tapes.each do |tape|
        docs = tape.data
        next if docs.nil?

        version = project.update_version(docs)
        unless version.nil?
          tape.version = version
          project.save
        end
        tape.apply!
      end
    end
  end

end
