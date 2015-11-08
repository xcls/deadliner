class DashboardsController < ApplicationController
  before_action :authenticate_user!, except: [:show]

  def show
    dashboard = Dashboard.find_by!(link_slug: params[:link_slug])
    if dashboard.published?
      pm = ProjectManager.new(dashboard.user)
      render 'partials/_project_overview', layout: 'simple', locals: {
        dashboard: dashboard,
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
    render layout: 'simple', locals: {
      github_user: pm.github_user,
      dashboard: dashboard,
    }
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

  def show_deadline
    dashboard = Dashboard.find_by_link_slug(params[:link_slug])
    pm = ProjectManager.new(dashboard.user)
    render 'partials/_deadline', layout: 'simple', locals: {
      dashboard: dashboard,
      project: pm.find_project(dashboard.project_uid),
      deadline: pm.find_deadline(dashboard.project_uid, params[:id]),
      tasks: pm.tasks_for(dashboard.project_uid, params[:id])
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
