FactoryBot.define do
    factory :user do
        trait :student do
            name { 'Student' }
            username {'student'}
        end
        trait :admin do
            name { 'Admin' }
            username {'admin'}
            after(:build) do |user,_|
                user.add_role(:admin)
            end
        end
        password { "123456" }
        sequence(:email) { |i| "user#{i}@example.org" }
    end
end