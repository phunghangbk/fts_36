class Admin::QuestionsController < ApplicationController
  load_and_authorize_resource

  def index
    @questions = @questions.paginate page: params[:page]
  end

  def new
    @question = Question.new
    @categories = Category.all
    4.times {@question.answers.build}
  end

  def create
    @question = Question.new question_params
    if @question.save
      flash[:success] = t "create_success"
      redirect_to admin_questions_path
    else
      @categories = Category.all
      render :new
    end
  end

  def edit
    @categories = Category.all
  end

  def update
    if @question.update_attributes question_params
      flash[:success] = t "update_success"
      redirect_to admin_questions_path
    else
      @categories = Category.all
      render :edit
    end
  end

  def destroy
    if @question.destroy
      flash[:success] = t "delete_success"
    else
      flash[:danger] = t "delete_failed"
    end
    redirect_to admin_questions_path
  end

  private
  def question_params
    params.require(:question).permit :content, :category_id,
      answers_attributes: [:id, :content, :correct, :_destroy]
  end
end
