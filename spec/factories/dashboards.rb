FactoryGirl.define do
  factory :dashboard do
    project_uid "octocat/Hello-World"
    user
    slug { project_uid.underscore }
    password { SecureRandom.hex(5) }
    show_tasks { [true, false].sample }
    published { [true, false].sample }
  end
end
