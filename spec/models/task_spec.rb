require 'rails_helper'

RSpec.describe Task, type: :model do
  context "methods" do
    before do
      @user = FactoryBot.create(:user)
      FactoryBot.create(:task, status: "Incomplete")
      FactoryBot.create(:task, status: "In progress")
      FactoryBot.create(:task, status: "Done")
    end

    describe "tasks_with_appointments" do
      it "only returns a users incomplete tasks that have appointments schedualed", :aggregate_failures do
        user2 = FactoryBot.create(:user)
        FactoryBot.create(:task, status: "Incomplete", date: "12/06/2023", time: "7:00am", user_id: user2.id)
        FactoryBot.create(:task, status: "Incomplete", date: "", time: "", user_id: @user.id)

        tasks_with_appointments = Task.tasks_with_appointments(@user)
        expect(tasks_with_appointments.count).to eq 1
        expect(tasks_with_appointments.first.status).to eq "Incomplete"
        expect(tasks_with_appointments.first.date).to eq "11/30/2025"
        expect(tasks_with_appointments.first.time).to eq "1:00pm"
        expect(tasks_with_appointments.first.user_id).to eq @user.id
      end
    end
  end

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

    describe "time has the correct format" do
      it "is valid with correctly formatted times", :aggregate_failures do
        expect(@task.update(time: "")).to eq true

        expect(@task.update(time: "1:00pm")).to eq true
        expect(@task.update(time: "9:00am")).to eq true

        expect(@task.update(time: "11:00am")).to eq true
        expect(@task.update(time: "10:00pm")).to eq true
      end

      it "is invalid for incorrectly short formatted times", :aggregate_failures do
        expect(@task.update(time: "5:00x")).to eq false
        expect(@task.update(time: "8:00y")).to eq false
        expect(@task.update(time: "9:00xy")).to eq false

        expect(@task.update(time: "3:00a")).to eq false
        expect(@task.update(time: "9:00m")).to eq false
        expect(@task.update(time: "2:00mp")).to eq false
        expect(@task.update(time: "7:00ma")).to eq false

        expect(@task.update(time: "3?30am")).to eq false
        expect(@task.update(time: "4^45pm")).to eq false

        expect(@task.update(time: "7:weam")).to eq false
        expect(@task.update(time: "}:00pm")).to eq false
        expect(@task.update(time: "(:^#pm")).to eq false
        expect(@task.update(time: "awful time")).to eq false
      end

      it "is invalid for incorrectly long formatted times", :aggregate_failures do
        expect(@task.update(time: "10:00a")).to eq false
        expect(@task.update(time: "11:00z")).to eq false
        expect(@task.update(time: "12:00az")).to eq false

        expect(@task.update(time: "10:00a")).to eq false
        expect(@task.update(time: "11:00p")).to eq false
        expect(@task.update(time: "12:00m")).to eq false
        expect(@task.update(time: "12:00ma")).to eq false
        expect(@task.update(time: "10:00mp")).to eq false

        expect(@task.update(time: "11/00pm")).to eq false
        expect(@task.update(time: "12&00am")).to eq false

        expect(@task.update(time: "12:0upm")).to eq false
        expect(@task.update(time: "@$:00am")).to eq false
        expect(@task.update(time: "%^:&*pm")).to eq false
        expect(@task.update(time: "its time to say hello world")).to eq false
      end
    end

    it "date has the correct format", :aggregate_failures do
      expect(@task.update(date: "")).to eq true
      expect(@task.update(date: "08/15/2023")).to eq true

      expect(@task.update(date: "/15/2023")).to eq false
      expect(@task.update(date: "08//2023")).to eq false
      expect(@task.update(date: "08/15/")).to eq false

      expect(@task.update(date: "08!15/2023")).to eq false
      expect(@task.update(date: "08/15.2023")).to eq false
      expect(@task.update(date: "08,15?2023")).to eq false

      expect(@task.update(date: "a8/15/2023")).to eq false
      expect(@task.update(date: "08/1x/2!23")).to eq false
      expect(@task.update(date: "08/15/202@")).to eq false
      expect(@task.update(date: "08/1#/2023")).to eq false
      expect(@task.update(date: "!@/#./%^&*")).to eq false
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
