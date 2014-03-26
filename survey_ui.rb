require 'active_record'
require './lib/survey'
require './lib/question'

database_configuration = YAML::load(File.open('./db/config.yml'))
development_configuration = database_configuration["development"]
ActiveRecord::Base.establish_connection(development_configuration)


def welcome
  puts "Welcome to our Survey"
  menu
end

def menu
  choice = nil
  until choice == 'x'
    puts "\n\nPress 'c' to create a new Survey"
    puts "Press 't' to take a survey"
    puts "Press 'l' to list all surveys"
    puts "Press 'lq' to see the questions in a survey"
    puts "Press 'aq' to add questions to your survey"
    puts "Press 'x' to exit"
    choice = gets.chomp
    case choice
    when 'c'
      new_survey
    when 't'
      take_survey
    when 'l'
      list_survey
    when 'lq'
      list_survey_questions
    when 'aq'
      add_question_existing_survey
    when 'x'
      puts "Good bye!"
      exit
    else
      puts "Invalid option"
    end
  end
  menu
end

def new_survey
  puts "\n\n"
  print "Enter the name of the survey: "
  name = gets.chomp
  survey = Survey.create({ name: name })
  if survey.save
    puts "#{survey.name} was created!"
  else
    puts "\n\n"
    print "Error: "
    survey.errors.full_messages.each { |message| puts message }
  end
  choice = nil
  until choice == 'f'
    puts "Press 'a' to add another question or 'f' to finish survey."
    choice = gets.chomp
    case choice
    when 'a'
      add_question_to_new_survey(survey.id)
    when 'f'
      "Survey complete!"
    else
      "Invalid input"
    end
  end
  puts "\n\nYour survey is complete!"
  menu
end

def add_question_to_new_survey(survey_id)
  puts "\n"
  print "Enter the question you want to ask: "
  new_question = gets.chomp
  Question.create({ name: new_question, survey_id: survey_id})
  puts "\n\nQuestion added to survey!"
end

def add_question_existing_survey
  puts "\n\n"
  list_survey
  puts "Which Survey ID you'd like to update"
  survey_id = gets.chomp.to_i
   choice = nil
  until choice == 'f'
    puts "Press 'a' to add another question or 'f' to finish survey."
    choice = gets.chomp
    case choice
    when 'a'
    add_question_to_new_survey(survey_id)
    when 'f'
      "Survey complete!"
    else
      "Invalid input"
    end
  end
  puts "\n\nYour survey is complete!"
  menu
end


def list_survey_questions
  puts "\n\n"
  list_survey
  puts "Which Survey ID you'd like to view"
  survey_id = gets.chomp.to_i
  survey = Survey.find(survey_id)
  questions = Question.where(survey_id: survey.id)
  puts "\n\n#{survey.name}"
  questions.each { |question| puts question.name}
  menu
end

def list_survey
  puts "\n\n"
  Survey.all.each { |survey| puts "#{survey.id} - #{survey.name}" }
end

welcome





