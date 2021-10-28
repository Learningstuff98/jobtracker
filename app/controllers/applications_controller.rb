class ApplicationsController < ApplicationController
  before_action :authenticate_user!

  def new
    @application = Application.new
  end

  def create
    @application = current_user.applications.create(application_params)
    redirect_to application_path(@application)
  end

  def show
    @application = Application.find(params[:id])
  end

  def destroy
    application = Application.find(params[:id])
    application.destroy
    redirect_to root_path
  end

  private

  def application_params
    params.require(:application).permit(:company_name, :job_title, :tech_job, :remote)
  end

end
