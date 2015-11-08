FactoryGirl.define do
  factory :dashboard do
    project_uid "octocat/Hello-World"
    user
    link_slug { project_uid.underscore }
    password { SecureRandom.hex(5) }
    show_tasks false
    published false
  end
end
