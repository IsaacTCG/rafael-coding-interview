FactoryBot.define do
  factory :user do
    display_name { Faker::Name.name }
    email { Faker::Internet.email }
    company { create(:company) }

    username { "temp_username" }

    after(:create) do |user|
      user.update!(username: "user_#{user.company_id}_#{user.id}")
    end
  end
end
