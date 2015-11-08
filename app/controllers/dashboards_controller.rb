class DashboardsController < ApplicationController
  before_action :authenticate_user!, except: [:show]

  def show
    dashboard = Dashboard.find_by!(link_slug: params[:link_slug])
    if dashboard.published?
      pm = ProjectManager.new(dashboard.user)
      render 'projects/show', layout: 'simple', locals: {
        project: pm.find_project(dashboard.project_uid),
        deadlines: pm.deadlines_for(dashboard.project_uid),
      }
    else
      redirect_to root_url, notice: "Dashboard unavailable"
    end
  end

  def edit
    dashboard = current_user.dashboards
      .where(project_uid: params[:project_uid])
      .first_or_create!
    render locals: { dashboard: dashboard }
  end

  def update
    dashboard = current_user.dashboards.find(params[:id])
    if dashboard.update(dashboard_params)
      redirect_to edit_dashboard_path(project_uid: dashboard.project_uid),
        notice: t('notice.saved')
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
    params.require(:dashboard)
      .permit(:password, :show_tasks, :published, :project_uid, :link_slug)
  end
end
