class ProjectsController < ApplicationController
  before_action :authenticate_user!

  def index
    client = Octokit::Client.new(access_token: current_user.github_token)
    render locals: { projects: client.repos }

  end
end
