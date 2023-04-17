require 'rails_helper'

RSpec.describe User, type: :model do
  context "#search" do
    before do
      @user = FactoryBot.create(:user)
      FactoryBot.create(:application, company_name: "company 1")
      FactoryBot.create(:application, company_name: "company 2")
      FactoryBot.create(:application, company_name: "company 3")
    end

    it "when a search term is used it returns the correct result", :aggregate_failures do
      search_result = @user.search("1")
      expect(search_result.count).to eq 1
      expect(search_result.first.company_name).to eq "company 1"

      search_result = @user.search("2")
      expect(search_result.count).to eq 1
      expect(search_result.first.company_name).to eq "company 2"

      search_result = @user.search("3")
      expect(search_result.count).to eq 1
      expect(search_result.first.company_name).to eq "company 3"

      search_result = @user.search("ny 1")
      expect(search_result.count).to eq 1
      expect(search_result.first.company_name).to eq "company 1"

      search_result = @user.search("company")
      expect(search_result.count).to eq 3
    end

    it "when no search term is used it returns all the users applications" do
      search_result = @user.search("")
      expect(search_result.count).to eq 3
    end
  end
end
