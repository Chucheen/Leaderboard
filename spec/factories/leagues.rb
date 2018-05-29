FactoryBot.define do
  factory :league do
    name { "#{Faker::Name.LastName} League" }
  end
end
