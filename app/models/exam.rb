class Exam < ActiveRecord::Base
  belongs_to :category
  belongs_to :user

  has_many :questions, through: :results
  has_many :results, dependent: :destroy

  accepts_nested_attributes_for :results, allow_destroy: true

  before_create :create_default_status, :random_questions
  before_update :update_result, :send_result_mail
  after_create :remind_user
  
  scope :order_created, ->{order created_at: :desc}
  scope :faker_exam, ->{where(status: Settings.user.start)
    .where "created_at <= ?", 1.weeks.ago}

  def time_out?
    if started_at
      execute_time = (Time.zone.now - self.started_at).to_i
      max_time = self.category.max_time * 60
      execute_time >= max_time
    end
  end

  private
  def create_default_status
    self.status = Settings.user.start
  end

  def random_questions
    questions = self.category.questions.random_questions self.category.max_question
    questions.each{|question| self.results.build question: question}
  end

  def update_result
    mark = results.select do |result|
      result.answer && result.answer.correct
    end.count
    self.mark = "#{mark.to_s}/#{self.category.max_question}"
  end

  def send_result_mail
    ResultMailer.result_exam(self).deliver if time_out?
  end

  def remind_user
    RemindUserWorker.perform_in 2.hours, id
  end
end
