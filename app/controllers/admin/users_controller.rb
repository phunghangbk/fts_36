class Admin::UsersController < ApplicationController
  load_and_authorize_resource

  def index
    @search = User.search params[:q]
    @users = @search.result.page params[:page]

    respond_to do |format|
      format.html
      format.json {render json: [:admin, @users]}
      format.csv {send_data @users.to_csv}
    end
  end

  def update
    @user.update_attributes role: :admin
    respond_to do |format|
      format.html
      format.js
    end
  end

  def destroy
    @user.destroy ? flash[:success] = t("delete_success") : flash[:danger] = t("delete_fail")
    redirect_to admin_users_path 
  end
end
