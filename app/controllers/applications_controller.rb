class ApplicationsController < ApplicationController
  before_action :authenticate_user!

  def new
    @application = Application.new
  end

  def create
    @application = current_user.applications.create(application_params)
    if @application.valid?
      redirect_to application_path(@application)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @application = Application.find(params[:id])
  end

  def destroy
    application = Application.find(params[:id])
    application.destroy
    redirect_to root_path
  end

  def edit
    @application = Application.find(params[:id])
  end

  def update
    @application = Application.find(params[:id])
    @application.update(application_params)
    if @application.valid?
      redirect_to application_path(@application)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def application_params
    params.require(:application).permit(:company_name, :job_title, :tech_job, :remote, :content)
  end

end
