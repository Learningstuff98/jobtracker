require 'rails_helper'

RSpec.describe "Applications", type: :request do
  describe "GET #index" do
    it "should load the page" do
      get root_path
      expect(response).to be_successful
    end
  end

  context "while logged in" do
    before do
      @user = FactoryBot.create(:user)
      sign_in(@user)
    end

    describe "GET #new" do
      it "loads the page" do
        get new_application_path
        expect(response).to be_successful
      end
    end

    describe "POST #create" do
      it "creates a new job application", :aggregate_failures do
        post applications_path(
          user_id: @user.id,
          application: {
            company_name: "some tech company",
            job_title: "software engineer",
            content: "relevent info",
            tech_job: true,
            remote: true
          }
        )
        expect(response).to have_http_status(:found)
        expect(Application.count).to eq 1
        application = Application.first
        expect(application.company_name).to eq "some tech company"
        expect(application.job_title).to eq "software engineer"
        expect(application.tech_job).to eq true
        expect(application.remote).to eq true
      end
    end

    describe "GET #show" do
      it "loads the page" do
        get application_path(FactoryBot.create(:application))
        expect(response).to be_successful
      end
    end
  end
end
