class ProjectsController < ApplicationController
  before_action :authenticate_user!

  def index
    render layout: 'simple', locals: {
      github_user: pm.github_user,
      projects: pm.projects(page: params[:page])
    }
  end

  def show
    render locals: {
      project: pm.find_project(params[:id]),
      deadlines: pm.deadlines_for(params[:id]),
    }
  end
end
