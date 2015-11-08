require 'rails_helper'

RSpec.feature "Viewing projects", type: :feature do
  let(:user) { create(:user, github_token: "TOKEN") }

  before :all do
    WebMock.disable_net_connect!
    GithubResponses.stub_all
  end

  before :each do
    login_as user, scope: :user
  end

  scenario "I can see my projects" do
    visit projects_path
    expect(page).to have_content("Hello-World")
  end

  scenario "I can see the details of a project" do
    visit projects_path
    click_on("Hello-World")
    expect(page).to have_content("octocat/Hello-World")
    expect(page).to have_content("v1.0") # name of the milestone
    expect(page).to have_content("4 open, 8 closed")
  end

  scenario "I can see the deadlines on the project detail page" do
    visit projects_path
    click_on("Hello-World")
    expect(page).to have_content("v1.0")
  end

  scenario "I can see the tasks on the deadline detail page" do
    visit projects_path
    click_on("Hello-World")
    click_on("v1.0")
    expect(page).to have_content("Found a bug")
    expect(page).to have_content("It's not working")
  end
end
