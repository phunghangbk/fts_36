class Question < ActiveRecord::Base
  belongs_to :category

  has_many :exams, through: :results
  has_many :results, dependent: :destroy
  has_many :answers, dependent: :destroy

  accepts_nested_attributes_for :answers, allow_destroy: true,
    reject_if: :all_blank

  validates :content, presence: true, length: {maximum: 60}
  validates :category_id, presence: true
  validate :check_correct_answers_num

  scope :random_questions, ->number{order("RANDOM()").limit(number)}

  def check_correct_answers_num
    correct_answers_num = answers.select{|ans| ans.correct}.count
    unless correct_answers_num == 1
      errors.add :base, I18n.t("wrong_num_correct_answers",
        content: content)
    end
  end

end
