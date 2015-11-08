class DashboardsController < ApplicationController
  before_action :authenticate_user!

  def show
    dashboard = Dashboard.find_by_link_slug(params[:link_slug])
    pm = ProjectManager.new(dashboard.user)
    render locals: {
      project: pm.find_project(dashboard.project_identifier),
      deadlines: pm.deadlines_for(dashboard.project_identifier),
    }
  end

  def edit
    dashboard = current_user.dashboards
      .where(project_identifier: params[:project_identifier])
      .first_or_create!
    render locals: { dashboard: dashboard }
  end

  def update
    dashboard = Dashboard.find(params[:id])
    if dashboard.update_attributes(dashboard_params)
      redirect_to projects_path
    else
      render :edit, locals: { dashboard: dashboard }
    end
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
    params.require(:dashboard)
      .permit(:password, :show_tasks, :published, :project_identifier)
  end
end
