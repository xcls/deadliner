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

  scenario "I can't see the tasks of a deadline if show_tasks is false for the dashboard" do
    dash = create(:dashboard, {
      published: true,
      show_tasks: false,
      slug: 'my-dash',
      password: ''
    })

    visit show_deadline_path(slug: dash.slug, id: 1)

    expect(page).to have_content("octocat/Hello-World")
  end

  scenario "I can see the tasks of a deadline if show_tasks is true for the dashboard" do
    dash = create(:dashboard, {
      published: true,
      show_tasks: true,
      slug: 'my-dash',
      password: ''
    })

    visit show_deadline_path(slug: dash.slug, id: 1)


    expect(page).to have_content("This is milestone 1")
  end

  scenario "I can see the sign in button when on external dashboard" do
    dash = create(:dashboard, {
      published: true,
      show_tasks: false,
      slug: 'my-dash',
      password: ''
    })

    visit show_deadline_path(slug: dash.slug, id: 1)

    expect(page).to have_content("Sign in")
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

    visit edit_dashboard_path(project_uid: 'octocat/Hello-World')

    within('#general-form') do
      fill_in :dashboard_slug, with: "octo"
      check :dashboard_published
      click_on "Save"
    end

    fill_in :dashboard_password, with: "secretstuff"
    within('#password-form') do
      click_on "Save"
    end
    expect(page).to have_content(I18n.t('notice.saved'))

    basic_authorize('octo', 'secretstuff')
    visit show_dashboard_path('octo')
    expect(page).to have_content('octocat/Hello-World')
    expect(page).to have_content('4 open, 8 closed')
  end
end
