namespace :dd do
  task init: :environment do
    ap DocDigger.scan(Rails.root, '*im.rb').as_json
  end

  task import: :environment do
    project = Project.find_by(name: :devise)
    docs = JSON.parse(File.new("#{Rails.root}/public/mocks/im.json").gets, { symbolize_names: true })
    project.update_version(docs)
    project.save
    ap project.errors
  end
end