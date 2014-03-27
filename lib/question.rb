class Question < ActiveRecord::Base
  belongs_to :survey
  has_one :observation, through: :answers
  has_many :answers
end
