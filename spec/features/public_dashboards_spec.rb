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
end
