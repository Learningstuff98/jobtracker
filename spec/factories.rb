FactoryBot.define do
  factory :task do
    
  end

  factory :user do
    sequence :email do |n|
      "dummyEmail#{n}@gmail.com"
    end
    password { "secretPassword" }
    password_confirmation { "secretPassword" }
  end

  factory :application do
    user_id { User.first.id }
    company_name { "a company" }
    job_title { "software engineer" }
    content { "relevent info" }
    tech_job { true }
    remote { true }
  end
end
