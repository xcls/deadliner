require 'rails_helper'

RSpec.feature "Viewing dashboards", type: :feature do
  let(:user) { create(:user, github_token: "TOKEN") }
  let!(:dashboard) { create(:dashboard, user: user, slug: "secrethash") }

  before :all do
    WebMock.disable_net_connect!
    GithubResponses.stub_all
  end

  scenario "A dashboard is publicly visible when published" do
    dashboard.update!(password: nil, published: true)
    visit show_dashboard_path(dashboard.slug)
    expect(page).to have_content("octocat/Hello-World")
  end

  scenario "A dashboard can't be reached if not published" do
    dashboard.update!(published: false)
    visit show_dashboard_path(dashboard.slug)
    expect(page).to have_content("Dashboard unavailable")
  end
end
