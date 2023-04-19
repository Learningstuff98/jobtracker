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
      it "can create tasks" do
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
    end

    describe "GET #show" do
      it "loads the page" do
        task = FactoryBot.create(:task)
        get task_path(task)
        expect(response).to be_successful
      end
    end

    describe "DELETE #destroy" do
      it "deletes tasks" do
        task = FactoryBot.create(:task)
        delete task_path(task)
        expect(response).to have_http_status(:found)
        expect(Task.count).to eq 0
      end
    end
  end
end
