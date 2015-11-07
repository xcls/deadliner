class ProjectsController < ApplicationController
  before_action :authenticate_user!

  def index
    render layout: 'simple', locals: {
      github_user: pm.github_user,
      projects: pm.projects(page: params[:page])
    }
  end

  def show
    uid = params[:uid] || params[:id]
    render locals: {
      project: pm.find_project(uid),
      deadlines: pm.deadlines_for(uid),
    }
  end
end
