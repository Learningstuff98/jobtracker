require 'rails_helper'

RSpec.describe "Applications CRUD operations", type: :system do
  context "when a user is logged in" do
    before do
      @user = FactoryBot.create(:user)
      @application = FactoryBot.create(:application)
      sign_in(@user)
    end

    it "can make new job applications", :aggregate_failures do
      visit root_path
      click_link "Add a new application"
      fill_in("Company name", with: "some company name")
      fill_in("Job title", with: "software engineer")
      check "Tech job"
      check "Remote"
      click_on "Submit"

      expect(page).to have_content "some company name"
      expect(page).to have_content "software engineer"
      expect(page).to have_content "This is a tech job"
      expect(page).to have_content "This job is remote"
    end

    it "can make edits to job applications", :aggregate_failures do
      visit application_path(@application)
      click_link "Edit"
      fill_in("Company name", with: "a different company")
      fill_in("Job title", with: "senior garbage disposal specialist")
      uncheck "Tech job"
      uncheck "Remote"
      click_on "Update"

      expect(page).to have_content "a different company"
      expect(page).to have_content "senior garbage disposal specialist"
      expect(page).not_to have_content "This is a tech job"
      expect(page).not_to have_content "This job is remote"
    end
  end
end
