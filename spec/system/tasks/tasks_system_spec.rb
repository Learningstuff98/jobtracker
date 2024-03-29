require 'rails_helper'

RSpec.describe "Tasks CRUD operations", type: :system do
  context "when a user is logged in" do
    before do
      @user = FactoryBot.create(:user)
      @task = FactoryBot.create(:task)
      sign_in(@user)
    end

    it "can make new tasks", :aggregate_failures do
      visit tasks_path
      click_link "Add a new task"

      expect(page).to have_content "Task Info"
      fill_in("Title", with: "Go to the dentist")
      fill_in("Date", with: "07/21/2525")
      fill_in("Time", with: "1:00pm")
      fill_in("Location", with: "middle of nowhere")
      find(".trix-content").set("some relevent info")
      click_on "Submit"

      expect(page).to have_content "Go to the dentist"
      expect(page).to have_content "07/21/2525"
      expect(page).to have_content "1:00pm"
      expect(page).to have_content "middle of nowhere"
      expect(page).to have_content "some relevent info"
    end

    it "can edit tasks", :aggregate_failures do
      visit task_path(@task)
      click_link "Edit"

      expect(page).to have_content "Edit task Info"
      fill_in("Title", with: "go to the dentist EDIT")
      fill_in("Date", with: "12/10/3050")
      fill_in("Time", with: "11:00am")
      fill_in("Location", with: "some address EDIT")
      find(".trix-content").set("relevent info EDIT")
      click_on "Update"

      expect(page).to have_content "go to the dentist EDIT"
      expect(page).to have_content "12/10/3050"
      expect(page).to have_content "11:00am"
      expect(page).to have_content "some address EDIT"
      expect(page).to have_content "relevent info EDIT"
    end

    it "can delete tasks", :aggregate_failures do
      visit task_path(@task)
      accept_confirm do
        click_on "Delete"
      end

      expect(page).to have_content "Add a new task"
      expect(page).not_to have_content "go to the dentist"
    end

    it "displays the correct error message when an invalid status value is used" do
      visit task_path(@task)
      click_link "Edit"

      expect(page).to have_content "Edit task Info"
      fill_in("Status", with: "apples")
      click_on "Update"

      expect(page).to have_content "Status must be one of the following: Incomplete, In progress or Done"
    end

    it "displays the correct error message when an invalid time value is used", :aggregate_failures do
      visit edit_task_path(@task)
      expect(page).to have_content "Edit task Info"

      fill_in("Time", with: "Hello World")
      click_on "Update"

      expect(page).to have_content(
        "Time must follow one of two formats, X:XX or XX:XX, with X being a number, followed by am or pm."
      )
    end

    it "displays the correct error message when an invalid date value is used", :aggregate_failures do
      visit edit_task_path(@task)
      expect(page).to have_content "Edit task Info"

      fill_in("Date", with: "apples")
      click_on "Update"

      expect(page).to have_content("Date must have the following format, XX/XX/XXXX with X being a number.", count: 1)

      fill_in("Date", with: "10/21/202")
      click_on "Update"

      expect(page).to have_content("Date must have the following format, XX/XX/XXXX with X being a number.", count: 1)

      fill_in("Date", with: "10!21/2028")
      click_on "Update"

      expect(page).to have_content("Date must have the following format, XX/XX/XXXX with X being a number.", count: 1)

      fill_in("Date", with: "10/21/20@8")
      click_on "Update"

      expect(page).to have_content("Date must have the following format, XX/XX/XXXX with X being a number.", count: 1)
    end

    it "displays tasks in the correct stage on the index page", :aggregate_failures do
      visit tasks_path
      within(".incomplete") do
        expect(page).to have_content("go to the dentist")
      end

      within(".in_progress") do
        expect(page).not_to have_content("go to the dentist")
      end

      within(".done") do
        expect(page).not_to have_content("go to the dentist")
      end

      @task.update(status: "In progress")
      visit tasks_path

      within(".incomplete") do
        expect(page).not_to have_content("go to the dentist")
      end

      within(".in_progress") do
        expect(page).to have_content("go to the dentist")
      end

      within(".done") do
        expect(page).not_to have_content("go to the dentist")
      end

      @task.update(status: "Done")
      visit tasks_path

      within(".incomplete") do
        expect(page).not_to have_content("go to the dentist")
      end

      within(".in_progress") do
        expect(page).not_to have_content("go to the dentist")
      end

      within(".done") do
        expect(page).to have_content("go to the dentist")
      end
    end

    it "displays upcoming appointments on the index page", :aggregate_failures do
      @task.update(status: "Incomplete")
      visit tasks_path

      expect(page).to have_content("Upcoming Appointments")
      expect(page).to have_content("11/30/2025")
      expect(page).to have_content("1:00pm")
      within(".appointments") do
        expect(page).to have_content("go to the dentist")
      end
      expect(page).not_to have_content("No upcoming appointments")

      @task.update(status: "Done")
      visit tasks_path

      expect(page).not_to have_content("Upcoming Appointments")
      expect(page).not_to have_content("11/30/2025")
      expect(page).not_to have_content("1:00pm")
      within(".appointments") do
        expect(page).not_to have_content("go to the dentist")
      end
      expect(page).to have_content("No upcoming appointments")

      @task.update(status: "Incomplete", date: "", time: "")
      visit tasks_path

      expect(page).not_to have_content("Upcoming Appointments")
      within(".appointments") do
        expect(page).not_to have_content("go to the dentist")
      end
      expect(page).to have_content("No upcoming appointments")
    end
  end
end
