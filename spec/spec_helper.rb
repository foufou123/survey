require 'active_record'
require 'rspec'
require 'shoulda-matchers'
require 'survey'


database_configuration = YAML::load(File.open('./db/config.yml'))
test_configuration = database_configuration["development"]
ActiveRecord::Base.establish_connection(test_configuration)

RSpec.configure do |config|
  config.after(:each) do
    Survey.all.each { |survey| survey.destroy }
  end
end
