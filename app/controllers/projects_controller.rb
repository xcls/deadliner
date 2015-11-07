class ProjectsController < ApplicationController
  before_action :authenticate_user!

  def index
    render locals: { projects: pm.projects }
  end
end
