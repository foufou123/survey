class Survey < ActiveRecord::Base

  has_many :questions
  has_many :answers, through: :questions
  validates :name, uniqueness: true, presence: true
end
