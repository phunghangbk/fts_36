class Exam < ActiveRecord::Base
  belongs_to :category
  belongs_to :user

  has_many :questions, through: :results
  has_many :results, dependent: :destroy
end
