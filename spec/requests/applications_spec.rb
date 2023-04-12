require 'rails_helper'

RSpec.describe "Applications", type: :request do
  describe "GET #index" do
    it "should load the page" do
      get root_path
      expect(response).to be_successful
    end
  end

  context "while logged in as a different user" do
    before do
      @user = FactoryBot.create(:user)
      @application = FactoryBot.create(:application)
      @user.applications.push(@application)
      @user2 = FactoryBot.create(:user)
      sign_in(@user2)
    end

    describe "GET #show" do
      it "doesn't allow access to foreign users" do
        get application_path(@application)
        expect(response).to have_http_status(:forbidden)
      end
    end

    describe "DELETE #destroy" do
      it "doesn't let foreign users delete job applications", :aggregate_failures do
        delete application_path(@application)
        expect(response).to have_http_status(:forbidden)
        expect(Application.count).to eq 1
      end
    end

    describe "GET #edit" do
      it "doesn't allow access to foreign users" do
        get edit_application_path(@application)
        expect(response).to have_http_status(:forbidden)
      end
    end

    describe "PATCH #update" do
      it "doesn't let foreign users update job applications", :aggregate_failures do
        patch application_path(
          id: @application.id,
          application: {
            company_name: "some troll name",
            job_title: "some troll title"
          }
        )
        expect(response).to have_http_status(:forbidden)
        application = Application.first
        expect(application.company_name).to eq "a company"
        expect(application.job_title).to eq "software engineer"
      end
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

      it "doesn't allow for the creation of invalid job applications", :aggregate_failures do
        post applications_path(
          user_id: @user.id,
          application: {
            company_name: "",
            job_title: ""
          }
        )
        expect(response).to have_http_status(:unprocessable_entity)
        expect(Application.count).to eq 0
      end
    end

    describe "GET #show" do
      it "loads the page" do
        get application_path(FactoryBot.create(:application))
        expect(response).to be_successful
      end
    end

    describe "DELETE #destroy" do
      it "deletes job applications", :aggregate_failures do
        delete application_path(FactoryBot.create(:application))
        expect(response).to have_http_status(:found)
        expect(Application.count).to eq 0
      end
    end

    describe "GET #edit" do
      it "loads the page" do
        get edit_application_path(FactoryBot.create(:application))
        expect(response).to be_successful
      end
    end

    describe "PATCH #update" do
      it "updates job applications", :aggregate_failures do
        application = FactoryBot.create(:application)
        patch application_path(
          id: application.id,
          application: {
            company_name: "new name",
            job_title: "new title",
            content: "new relevent info",
            tech_job: false,
            remote: false
          }
        )
        expect(response).to have_http_status(:found)
        application = Application.first
        expect(application.company_name).to eq "new name"
        expect(application.job_title).to eq "new title"
        expect(application.tech_job).to eq false
        expect(application.remote).to eq false
      end

      it "doesn't allow for the updating of invalid job applications", :aggregate_failures do
        application = FactoryBot.create(:application)
        patch application_path(
          id: application.id,
          application: {
            company_name: "",
            job_title: ""
          }
        )
        expect(response).to have_http_status(:unprocessable_entity)
        application = Application.first
        expect(application.company_name).to eq "a company"
        expect(application.job_title).to eq "software engineer"
      end
    end
  end
end
