class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  include Redis::Objects
end
