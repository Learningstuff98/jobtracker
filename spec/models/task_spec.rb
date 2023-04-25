require 'rails_helper'

RSpec.describe Task, type: :model do
  context "scopes" do
    before do
      @user = FactoryBot.create(:user)
      FactoryBot.create(:task, status: "Incomplete")
      FactoryBot.create(:task, status: "In progress")
      FactoryBot.create(:task, status: "Done")
    end

    describe "completed_tasks" do
      it "only returns a users completed tasks", :aggregate_failures do
        user2 = FactoryBot.create(:user)
        FactoryBot.create(:task, status: "Done", user_id: user2.id)

        completed_tasks = Task.completed_tasks(@user)
        expect(completed_tasks.count).to eq 1
        expect(completed_tasks.first.status).to eq "Done"
        expect(completed_tasks.first.user_id).to eq @user.id
      end
    end

    describe "incomplete_tasks" do
      it "only returns a users incomplete tasks", :aggregate_failures do
        user2 = FactoryBot.create(:user)
        FactoryBot.create(:task, status: "Incomplete", user_id: user2.id)

        incomplete_tasks = Task.incomplete_tasks(@user)
        expect(incomplete_tasks.count).to eq 1
        expect(incomplete_tasks.first.status).to eq "Incomplete"
        expect(incomplete_tasks.first.user_id).to eq @user.id
      end
    end

    describe "in_progress_tasks" do
      it "only returns a users tasks that are in progress" do
        user2 = FactoryBot.create(:user)
        FactoryBot.create(:task, status: "In progress", user_id: user2.id)

        in_progress_tasks = Task.in_progress_tasks(@user)
        expect(in_progress_tasks.count).to eq 1
        expect(in_progress_tasks.first.status).to eq "In progress"
        expect(in_progress_tasks.first.user_id).to eq @user.id
      end
    end
  end

  context "validations" do
    before do
      @user = FactoryBot.create(:user)
      @task = FactoryBot.create(:task)
    end

    it "title can't be blank" do
      expect(@task.update(title: "")).to eq false
    end

    it "status can only be one of three options: Incomplete, In progress or Done", :aggregate_failures do
      expect(@task.update(status: "Incomplete")).to eq true
      expect(@task.update(status: "In progress")).to eq true
      expect(@task.update(status: "Done")).to eq true

      expect(@task.update(status: "Hello World")).to eq false
      expect(@task.update(status: "apples")).to eq false
      expect(@task.update(status: "")).to eq false
    end
  end
end
