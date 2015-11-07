class DashboardsController < ApplicationController
  before_action :authenticate_user!

  def new
    @dashboard = current_user.dashboards.new()
    @project_identifier = params[:project_identifier]
  end

  def create
    @dashboard = current_user.dashboards.create(dashboard_params)

    if @dashboard.save
      redirect_to show_dashboard_path(link_slug: @dashboard.link_slug)
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

  def edit
    @dashboard = Dashboard.find_by(user: current_user, project_identifier: params[:project_identifier])
    @project_identifier = @dashboard.project_identifier
  end

  def update
    @dashboard = Dashboard.find(params[:id])
    if @dashboard.update_attributes(dashboard_params)
      redirect_to projects_path
    else
      render :edit
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

  def destroy
    @dashboard = Dashboard.find(params[:id])
    if @dashboard.destroy
      redirect_to projects_path
    else
      render :edit
    end
  end

  private

  def dashboard_params
    params.require(:dashboard).permit(:password, :show_tasks, :published,
                                      :project_identifier)
  end
end
