FactoryBot.define do
    factory :user do
        trait :student do
            name { 'Student' }
            username {'student'}
            email {'student@example.org'}
        end
        trait :admin do
            name { 'Admin' }
            username {'admin'}
            email {'admin@example.org'}
            after(:build) do |user,_|
                user.add_role(:admin)
            end
        end
        password { "123456" }
        sequence(:email) { |i| "user#{i}@example.org" }
    end
end