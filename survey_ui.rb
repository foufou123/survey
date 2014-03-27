require 'active_record'
require './lib/survey'
require './lib/question'
require './lib/answer'
require './lib/observation'
require 'pry'

database_configuration = YAML::load(File.open('./db/config.yml'))
development_configuration = database_configuration["development"]
ActiveRecord::Base.establish_connection(development_configuration)
@survey = nil
@questions = nil
@user = nil

def welcome
  puts "Welcome to our Survey"
  print "\nAre a survey [taker] or [designer]? "
  @user = gets.chomp
  case @user
  when "designer"
    menu
  when "taker"
    take_survey
  end
end

def menu
  choice = nil
  until choice == 'x'
    puts "\n\nPress 'c' to create a new Survey"
    puts "Press 'l' to list all surveys"
    puts "Press 'lq' to see the questions in a survey"
    puts "Press 'aq' to add questions to your survey"
    puts "Press 'aa' to add possible answers to existing questions"
    puts "Press 'vd' to view database"
    puts "Press 'x' to exit"
    choice = gets.chomp
    case choice
    when 'c'
      new_survey
    when 'l'
      list_survey
    when 'lq'
      list_survey_questions
    when 'aq'
      add_question_existing_survey
    when 'aa'
      add_answer_to_existing_question
    when 'vd'
      view_database
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
      add_question_to_new_survey(survey)
    when 'f'
      "Survey complete!"
    else
      "Invalid input"
    end
  end
  puts "\n\nYour survey is complete!"
  menu
end

def add_question_to_new_survey(survey)
  puts "\n"
  print "Enter the question you want to ask: "
  new_question = gets.chomp
  survey.questions.create({ name: new_question })
  puts "\n\nQuestion added to survey!"
end

def add_answer_to_existing_question
  puts "\n\n"
  list_survey
  puts "Which Survey ID you'd like to update?"
  survey_id = gets.chomp.to_i
  @survey = Survey.find(survey_id)
  @questions = Question.where(survey_id: @survey.id)
  puts "\n\n#{@survey.name}"
  choice = nil
  until choice == 'f'
    puts "Press 'a' to add another answer, 'n' to go to the next question, or 'f' to finish survey."
    choice = gets.chomp
    case choice
    when 'a'
    add_answer
    when 'f'
      "Survey complete!"
    else
      "Invalid input"
    end
  end
end

def add_answer
  @questions.each { |question| puts "#{question.id} - #{question.name}" }
  puts "Which question do you want to provide answers for?"
  choice = gets.chomp.to_i
  if choice == 'f'
    puts "Questions added!"
    menu
  else
    question = Question.find(choice)
    print "Enter a possible answer: "
    response = gets.chomp
    question.answers.create({response: response})
  end
end


def add_question_existing_survey
  puts "\n\n"
  list_survey
  puts "Which Survey ID you'd like to update"
  survey_id = gets.chomp.to_i
  survey = Survey.find(survey_id)
   choice = nil
  until choice == 'f'
    puts "Press 'a' to add another question or 'f' to finish survey."
    choice = gets.chomp
    case choice
    when 'a'
    add_question_to_new_survey(survey)
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
  questions.each { |question| puts "#{question.id} - #{question.name}" }
  menu
end

def list_survey
  puts "\n\n"
  Survey.all.each { |survey| puts "#{survey.id} - #{survey.name}" }
end

def view_database
  puts"\n\n"
  Survey.all.each do |survey|
    puts survey.name
    survey.questions.each do |question|
      puts "\t#{question.name}"
      question.answers.each do |answer|
        puts "\t\t#{answer.response}"
      end
    end
  end
end

def take_survey
  puts "\n\n"
  list_survey
  print "Choose a survey id: "
  survey_id = gets.chomp.to_i
  survey = Survey.find(survey_id)
  puts survey.name
  puts "\n"
  survey.questions.each do |question|
    puts "#{question.name}"
    question.answers.each do |answer|
      puts "#{answer.id} - #{answer.response}"
    end
    print "Choose a number: "
    feedback = gets.chomp.to_i
    chosen_answer = Answer.all[feedback]
    chosen_answer.observations.create({ feedback: feedback })
    puts "\n\n"
  end
  puts "Thanks for taking that survey!"
  print "Take another survey? "
  response = gets.chomp
  if response == 'yes'
    take_survey
  else
    welcome
  end
end

welcome





