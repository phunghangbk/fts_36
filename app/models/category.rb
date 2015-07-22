class Category < ActiveRecord::Base
  has_many :exams, dependent: :destroy
  has_many :questions, dependent: :destroy

  validates :name, presence: true, uniqueness: true, length: {maximum: 60}
  validates :max_question, presence: true, numericality: {only_integer: true,
    greater_than: 0}
  validates :max_time, presence: true, numericality: {only_integer: true, 
    greater_than: 0}
end
