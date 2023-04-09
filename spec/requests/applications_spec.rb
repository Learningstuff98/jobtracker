require 'rails_helper'

RSpec.describe "Applications", type: :request do
  describe "GET #index" do
    it "should load the page" do
      get root_path
      expect(response).to be_successful
    end
  end
end
