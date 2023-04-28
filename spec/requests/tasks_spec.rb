require 'rails_helper'

RSpec.describe "Tasks", type: :request do
  context "while logged in" do
    before do
      @user = FactoryBot.create(:user)
      sign_in(@user)
    end

    describe "GET #index" do
      it "loads the page" do
        get tasks_path
        expect(response).to be_successful
      end
    end

    describe "GET #new" do
      it "loads the page" do
        get new_task_path
        expect(response).to be_successful
      end
    end

    describe "POST #create" do
      it "can create tasks", :aggregate_failures do
        post tasks_path(
          user_id: @user.id,
          task: {
            title: "go to the dentist",
            date: "11/30/2025",
            time: "1:00pm",
            location: "some address"
          }
        )
        expect(response).to have_http_status(:found)
        expect(Task.count).to eq 1
        task = Task.first
        expect(task.title).to eq "go to the dentist"
        expect(task.date).to eq "11/30/2025"
        expect(task.time).to eq "1:00pm"
        expect(task.location).to eq "some address"
      end

      it "doesn't create invalid tasks", :aggregate_failures do
        post tasks_path(
          user_id: @user.id,
          task: {
            title: ""
          }
        )
        expect(response).to have_http_status(:unprocessable_entity)
        expect(Task.count).to eq 0
      end
    end

    describe "GET #show" do
      it "loads the page" do
        task = FactoryBot.create(:task)
        get task_path(task)
        expect(response).to be_successful
      end
    end

    describe "GET #edit" do
      it "loads the page" do
        task = FactoryBot.create(:task)
        get edit_task_path(task)
        expect(response).to be_successful
      end
    end

    describe "PATCH #update" do
      it "updates tasks", :aggregate_failures do
        task = FactoryBot.create(:task)
        patch task_path(
          id: task.id,
          task: {
            title: "go to the dentist EDIT",
            date: "11/30/2026",
            time: "1:00pm EDIT",
            location: "some address EDIT"
          }
        )
        expect(response).to have_http_status(:found)
        task = Task.first
        expect(task.title).to eq "go to the dentist EDIT"
        expect(task.date).to eq "11/30/2026"
        expect(task.time).to eq "1:00pm EDIT"
        expect(task.location).to eq "some address EDIT"
      end

      it "doesn't allow for invalid updates", :aggregate_failures do
        task = FactoryBot.create(:task)
        patch task_path(
          id: task.id,
          task: {
            title: ""
          }
        )
        expect(response).to have_http_status(:unprocessable_entity)
        expect(Task.first.title).to eq "go to the dentist"
      end
    end

    describe "DELETE #destroy" do
      it "deletes tasks", :aggregate_failures do
        task = FactoryBot.create(:task)
        delete task_path(task)
        expect(response).to have_http_status(:found)
        expect(Task.count).to eq 0
      end
    end
  end

  context "while logged in as a foreign user" do
    before do
      @user = FactoryBot.create(:user)
      @task = FactoryBot.create(:task)
      @user2 = FactoryBot.create(:user)
      sign_in(@user2)
    end

    describe "GET #show" do
      it "should deny access" do
        get task_path(@task)
        expect(response).to have_http_status(:forbidden)
      end
    end

    describe "GET #edit" do
      it "should deny access" do
        get edit_task_path(@task)
        expect(response).to have_http_status(:forbidden)
      end
    end

    describe "PATCH #update" do
      it "should deny access", :aggregate_failures do
        patch task_path(
          id: @task.id,
          task: {
            title: "some troll edit"
          }
        )
        expect(response).to have_http_status(:forbidden)
        expect(Task.first.title).to eq "go to the dentist"
      end
    end

    describe "DELETE #destroy" do
      it "should deny access", :aggregate_failures do
        delete task_path(@task)
        expect(response).to have_http_status(:forbidden)
        expect(Task.count).to eq 1
      end
    end
  end
end
