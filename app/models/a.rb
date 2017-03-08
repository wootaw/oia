require 'yaml'

class A < Settingslogic
  source "#{Rails.root}/config/application.yml"
  namespace Rails.env
  load!

  RESERVED_WORDS = YAML.load_file("#{Rails.root}/config/reserved_words.yml")
end