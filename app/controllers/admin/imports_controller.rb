class Admin::ImportsController < ApplicationController
  
  def create
    User.import params[:file]
    redirect_to admin_users_url, notice: t("import_succes")
  end
end
