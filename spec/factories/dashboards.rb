FactoryGirl.define do
  factory :dashboard do
    project_uid "octocat/Hello-World"
    user
    password { SecureRandom.hex(5) }
    show_tasks { [true, false].sample }
    published { [true, false].sample }

    factory :public_dashboard do
      password nil
      published false
    end
  end
end
