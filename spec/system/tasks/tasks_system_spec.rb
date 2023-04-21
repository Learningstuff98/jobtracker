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
      fill_in("Time", with: "1:00PM")
      fill_in("Location", with: "middle of nowhere")
      find(".trix-content").set("some relevent info")
      click_on "Submit"

      expect(page).to have_content "Go to the dentist"
      expect(page).to have_content "07/21/2525"
      expect(page).to have_content "1:00PM"
      expect(page).to have_content "middle of nowhere"
      expect(page).to have_content "some relevent info"
    end
  end
end
