class DashboardsController < ApplicationController
  before_action :authenticate_user!

  def new
    @dashboard = current_user.dashboards.new()
    @project_identifier = params[:project_identifier]
  end

  def create
    @dashboard = current_user.dashboards.create(dashboard_params)

    if @dashboard.save
      redirect_to dashboard_path(link_slug: @dashboard.link_slug)
    else
      render :new
    end
  end

  def show
    dashboard = Dashboard.find_by_link_slug(params[:link_slug])
    pm = ProjectManager.new(dashboard.user)
    render locals: {
      project: pm.find_project(dashboard.project_identifier),
      deadlines: pm.deadlines_for(dashboard.project_identifier),
    }
  end

  def show_milestone
    dashboard = Dashboard.find_by_link_slug(params[:link_slug])
    pm = ProjectManager.new(dashboard.user)
    render locals: {
      deadline: pm.find_deadline(params[:project_id], params[:id]),
      tasks: pm.tasks_for(params[:project_id], params[:id])
    }
  end

  private

  def dashboard_params
    params.require(:dashboard).permit(:password, :show_tasks, :published,
                                      :project_identifier)
  end
end
