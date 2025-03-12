FactoryBot.define do
  factory :tweet do
    body { Faker::GreekPhilosophers.quote }
    user { create(:user) }
  end
end
