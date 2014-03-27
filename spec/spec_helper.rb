require 'active_record'
require 'rspec'
require 'shoulda-matchers'
require 'pry'

require 'survey'
require 'question'
require 'answer'
require 'observation'


ActiveRecord::Base.establish_connection(YAML::load(File.open('./db/config.yml'))["test"])

RSpec.configure do |config|
  config.after(:each) do
    Survey.all.each { |survey| survey.destroy }
    Question.all.each { |question| question.destroy }
    Answer.all.each { |answer| answer.destroy }
    Observation.all.each { |observation| observation.destroy }
  end
end
