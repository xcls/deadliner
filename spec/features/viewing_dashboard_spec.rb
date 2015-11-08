require 'rails_helper'

RSpec.feature "Viewing dashboards", type: :feature do
  let(:user) { create(:user, github_token: "TOKEN") }
  let(:dashboard) { create(:dashboard, user: user, link_slug: "secrethash") }

  before :all do
    WebMock.disable_net_connect!
  end

  scenario "A dashboard is publicly visible when published" do
    visit show_dashboard_path(dashboard.link_slug)
    expect(page).to have_content("dashboard")
  end
end
