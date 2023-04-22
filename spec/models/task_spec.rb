require 'rails_helper'

RSpec.describe Task, type: :model do
  context "validations" do
    before do
      @user = FactoryBot.create(:user)
      @task = FactoryBot.create(:task)
    end

    it "status can only be one of three options, Incomplete, In progress or Done", :aggregate_failures do
      expect(@task.update(status: "Incomplete")).to eq true
      expect(@task.update(status: "In progress")).to eq true
      expect(@task.update(status: "Done")).to eq true

      expect(@task.update(status: "Hello World")).to eq false
      expect(@task.update(status: "apples")).to eq false
      expect(@task.update(status: "")).to eq false
    end
  end
end
