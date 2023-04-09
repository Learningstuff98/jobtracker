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
      user = FactoryBot.create(:user)
      sign_in(user)
    end

    describe "GET #new" do
      it "loads the page" do
        get new_application_path
        expect(response).to be_successful
      end
    end
  end
end
