require 'rails_helper'

RSpec.feature "Viewing projects", type: :feature do
  let(:user) { create(:user, github_token: "TOKEN") }

  before :each do
    WebMock.disable_net_connect!
    login_as user, scope: :user

    stub_request(:get, %r|https://api.github.com/user/repos(\?.*)?|).to_return(
      status: 200,
      body: GithubResponses.repositories,
      headers: { 'Content-Type'=>'application/json' }
    )
    stub_request(:get, "https://api.github.com/repos/octocat/Hello-World/milestones?state=open").to_return(
      status: 200,
      body: GithubResponses.milestones,
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

  scenario "I can see the deadlines on the project detail page" do
    stub_request(:get, "https://api.github.com/repos/octocat/Hello-World/milestones").to_return(
      status: 200,
      body: GithubResponses.milestones,
      headers: { 'Content-Type'=>'application/json' }
    )

    visit projects_path
    click_on("Hello-World")
    expect(page).to have_content("v1.0")
  end

  scenario "I can see the tasks on the deadline detail page" do
    stub_request(:get, "https://api.github.com/repos/octocat/Hello-World/milestones/1")
         .with(
      headers: {'Accept'=>'application/vnd.github.v3+json',
                'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
                'Authorization'=>'token TOKEN',
                'Content-Type'=>'application/json',
                'User-Agent'=>'Octokit Ruby Gem 4.1.1'})
         .to_return(
      status: 200,
      body: GithubResponses.milestone,
      headers: { 'Content-Type'=>'application/json' }
    )

    stub_request(:get, "https://api.github.com/repos/octocat/Hello-World/issues?milestone=1&state=all").to_return(
      status: 200,
      body: GithubResponses.issues,
      headers: { 'Content-Type'=>'application/json' }
    )

    visit projects_path
    click_on("Hello-World")
    click_on("v1.0")
    expect(page).to have_content("Found a bug")
    expect(page).to have_content("It's not working")
  end
end
