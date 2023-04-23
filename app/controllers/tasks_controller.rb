class TasksController < ApplicationController
  before_action :authenticate_user!

  def index
    @incomplete_tasks = Task.incomplete_tasks(current_user)
    @in_progress_tasks = Task.in_progress_tasks(current_user)
    @completed_tasks = Task.completed_tasks(current_user)
  end

  def new
    @task = Task.new
  end

  def create
    @task = current_user.tasks.create(task_params)
    if @task.save
      redirect_to task_path(@task)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @task = Task.find(params[:id])
    authorize_user(@task)
  end

  def edit
    @task = Task.find(params[:id])
    authorize_user(@task)
  end

  def update
    @task = Task.find(params[:id])
    return unless authorize_user(@task)

    if @task.update(task_params)
      redirect_to task_path(@task)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @task = Task.find(params[:id])
    return unless authorize_user(@task)

    @task.destroy
    redirect_to tasks_path
  end

  private

  def task_params
    params.require(:task).permit(:title, :date, :time, :location, :status, :content)
  end

  def authorize_user(task)
    if current_user != task.user
      render plain: 'Access Denied', status: :forbidden
      false
    else
      true
    end
  end
end
