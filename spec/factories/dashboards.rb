FactoryGirl.define do
  factory :dashboard do
    project_uid "octocat/Hello-World"
    user
    link_slug "MyString"
    password "MyString"
    show_tasks false
    published false
  end
end
