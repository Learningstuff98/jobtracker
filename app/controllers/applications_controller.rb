class ApplicationsController < ApplicationController
  before_action :authenticate_user!, only: %i[new create show edit update destroy]

  def index
    @applications = current_user.search(params[:keyword]) if current_user
  end

  def new
    @application = Application.new
  end

  def create
    @application = current_user.applications.create(application_params)
    if @application.save
      redirect_to application_path(@application)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @application = Application.find(params[:id])
    authorize_user(@application)
  end

  def destroy
    @application = Application.find(params[:id])
    return unless authorize_user(@application)

    @application.destroy
    redirect_to root_path
  end

  def edit
    @application = Application.find(params[:id])
    authorize_user(@application)
  end

  def update
    @application = Application.find(params[:id])
    return unless authorize_user(@application)

    if @application.update(application_params)
      redirect_to application_path(@application)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def application_params
    params.require(:application).permit(:company_name, :job_title, :tech_job, :remote, :content)
  end

  def authorize_user(application)
    if current_user != application.user
      render plain: 'Access Denied', status: :forbidden
      false
    else
      true
    end
  end
end
