FactoryBot.define do
    factory :user do
        trait :student do
            name { 'Student' }
            username {'student'}
            email {'student@example.org'}
        end
        trait :instructor do
            sequence(:name) { |n| "Instructor-#{n}" }
            sequence(:username) { |n| "instructor-#{n}" }
            sequence(:email) { |n| "instructor-#{n}@example.com" }
            after(:build) do |user,_|
                user.add_role(:instructor)
            end
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
    factory :course do
        to_create { |instance| instance.save(validate: false) }
        name { 'test-course' }
        course_organization { 'test-course-org' }
        hidden { false }
        transient do
            instructor { FactoryBot.create(:user, :instructor) }
        end
        after(:create) do |course, evaluator|
            FactoryBot.create(:role, resource_id: course.id, users: [evaluator.instructor])
        end
    end
    factory :role do
        name { 'instructor' }
        resource_type { 'Course' }
    end
    factory :roster_student do
        perm { 1234 }
        first_name { 'Student' }
        email { 'student@example.org' }
        enrolled { false }
        after(:build) do |roster_student, evaluator|
            roster_student.course = evaluator.course
            roster_student.user = evaluator.user
        end
    end
end 