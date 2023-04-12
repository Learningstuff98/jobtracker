class ApplicationsController < ApplicationController
  before_action :authenticate_user!, only: %i[new create show edit update destroy]
  before_action :authorize_user, only: %i[show destroy edit update]

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
  end

  def destroy
    @application.destroy
    redirect_to root_path
  end

  def edit
  end

  def update
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

  def authorize_user
    @application = Application.find(params[:id])
    if current_user != @application.user
      return render plain: 'Access Denied', status: :forbidden
    end
  end
end
