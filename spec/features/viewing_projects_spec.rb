require 'rails_helper'

RSpec.feature "Viewing projects", type: :feature do
  let(:user) { create(:user, github_token: "TOKEN") }

  before :each do
    WebMock.disable_net_connect!
    login_as user, scope: :user

    stub_request(:get, "https://api.github.com/user/repos").to_return(
      status: 200,
      body: GithubResponses.repositories,
      headers: { 'Content-Type'=>'application/json' }
    )
  end

  scenario "I can see my projects" do
    visit projects_path
    expect(page).to have_content("Hello-World")
  end

  scenario "I can see the details of a project" do
    stub_request(:get, "https://api.github.com/repos/octocat/Hello-World").to_return(
      status: 200,
      body: GithubResponses.repository,
      headers: { 'Content-Type'=>'application/json' }
    )

    visit projects_path
    click_on("Hello-World")
    expect(page).to have_content("Project: octocat/Hello-World")
  end
end
