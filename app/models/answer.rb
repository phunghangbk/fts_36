class Answer < ActiveRecord::Base
  belongs_to :question
  has_many :results, dependent: :destroy

  validates :content, presence: true, length: {maximum: 60}, uniqueness: true
end
