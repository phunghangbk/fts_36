class ExamsController < ApplicationController
  load_and_authorize_resource

  def index
    @exam = Exam.new
    @categories = Category.all
    @exams = @exams.order_created.paginate page: params[:page]
  end

  def show
  end

  def create
    @exam.user_id = current_user.id
    if @exam.save
      flash[:success] = t "create_success"
    else
      flash[:danger] = t "create_fail"
    end
    redirect_to exams_path
  end

  def edit
    if @exam.started_at.nil?
      started_at = Time.zone.now
      @exam.update_attributes status: Settings.user.view, started_at: started_at
    end
    @timeleft = @exam.category.max_time * 60 - (Time.zone.now - @exam.started_at).to_i
  end

  def update
    if @exam.update_attributes update_params
      flash[:success] = t "update_success"
    else
      flash[:danger] = t "update_fail"
    end
    redirect_to exams_path
  end

  private  
  def create_params
    params.require(:exam).permit :category_id
  end

  def update_params
    params.require(:exam).permit results_attributes: [:id, :answer_id]
  end
end
