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
    good:       35,
    attempting: 60,
    finished:   90
  }

  aasm column: :state, enum: true do
    state :mounted, initial: true
    state :broken, :invalided, :good, :attempting, :finished

    event :discard do
      transitions from: :mounted, to: :broken
    end

    event :invalidate do
      transitions from: [:mounted, :invalided], to: :invalided
    end

    event :pass do
      transitions from: [:mounted, :invalided], to: :good
    end

    event :attempt do
      transitions from: :good, to: :attempting
    end

    event :apply do
      transitions from: :good, to: :finished
    end
  end

  def data
    if self.broken?
      nil
    else
      begin
        @result ||= JSON.parse(self.content)
        if self.mounted? || self.invalided?
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

end
