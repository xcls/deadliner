class ProjectsController < ApplicationController
  before_action :authenticate_user!

  def index
    render locals: { projects: pm.projects }
  end

  def show
    render locals: {
      project: pm.find_project(params[:id])
    }
  end
end
