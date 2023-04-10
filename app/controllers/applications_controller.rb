class ApplicationsController < ApplicationController
  before_action :authenticate_user!, only: %i[new create show edit update destroy]

  def index # DONE
    @applications = current_user.search(params[:keyword]) if current_user
  end

  def new # DONE
    @application = Application.new
  end

  def create # DONE
    @application = current_user.applications.create(application_params)
    if @application.save
      redirect_to application_path(@application)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show # DONE
    @application = Application.find(params[:id])
  end

  def destroy # DONE
    @application = Application.find(params[:id])
    @application.destroy
    redirect_to root_path
  end

  def edit # DONE
    @application = Application.find(params[:id])
  end

  def update # NEXT
    @application = Application.find(params[:id])
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
end
