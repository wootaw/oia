guard :rspec, cmd: "bin/bundle exec rspec --color --format=doc --format=Nc" do
  # watch /lib/ files
  # watch(%r{^lib/(.+).rb$}) do |m|
  #   "spec/#{m[1]}_spec.rb"
  # end

  # watch /spec/ files
  watch(%r{^spec/(.+).rb$}) do |m|
    # "spec/#{m[1]}.rb"
    'spec/models/project_spec.rb'
  end
end

# guard :bundler, cmd: "bin/bundle install" do
#   watch('Gemfile')
# end