require 'rails_helper'

RSpec.feature "Public dashboards", type: :feature do
  before :all do
    GithubResponses.stub_all
  end

  scenario "I can visit password-protected dashboards with correct credentials" do
    dash = create(:dashboard, {
      published: true,
      slug: 'my-dash',
      password: 'secretstuff'
    })

    other_dash = create(:dashboard, {
      published: true,
      slug: 'not-my-dash',
      password: 'secretstuff'
    })

    basic_authorize(dash.slug, 'secretstuff')
    visit show_dashboard_path(dash.slug)
    expect(page).to have_content("octocat/Hello-World")

    # Can't access other project
    visit show_dashboard_path(other_dash.slug)
    expect(page).to have_content("HTTP Basic: Access denied.")

    # Can't access anymore if password changed
    dash.update!(password: 'it-changed-lol')
    visit show_dashboard_path(dash.slug)
    expect(page).to have_content("HTTP Basic: Access denied.")
  end

  def basic_authorize(name, password)
    driver = page.driver
    if driver.respond_to?(:basic_auth)
      driver.basic_auth(name, password)
    elsif page.driver.respond_to?(:basic_authorize)
      driver.basic_authorize(name, password)
    elsif driver.respond_to?(:browser) && driver.browser.respond_to?(:basic_authorize)
      driver.browser.basic_authorize(name, password)
    else
      fail "I don't know how to log in!"
    end
  end

  scenario "I can edit the general dashboard settings" do
    user = create(:user)
    login_as user, scope: :user

    visit projects_path
    find(".project .project-share").click

    expect(page).to have_content("Configure a public dashboard")
    fill_in :dashboard_slug, with: "the-project"
    check :dashboard_show_tasks
    check :dashboard_published
    first('#general-form').click_on "Save"

    visit show_dashboard_path("the-project")
    expect(page).to have_content("octocat/Hello-World")
  end

  scenario "I can edit the dashboard password" do
    user = create(:user)
    login_as user, scope: :user

    dashboard = create(:dashboard)

    visit edit_dashboard_path(project_uid: dashboard.project_uid)

    expect(page).to have_content("Configure a public dashboard")
    fill_in :dashboard_password, with: "secretstuff"
    first('#password-form').click_on "Save"


    dashboard.reload
    expect(dashboard.password == "secretstuff").to eq(true)
  end
end
