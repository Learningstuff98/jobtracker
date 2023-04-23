FactoryBot.define do
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

  factory :task do
    user_id { User.first.id }
    title { "go to the dentist" }
    date { "11/30/2025" }
    time { "1:00pm" }
    location { "some address" }
    content { "relevent info" }
  end
end
