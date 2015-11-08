class DashboardsController < ApplicationController
  before_action :authenticate_user!, except: [:show, :login, :authenticate]

  def show
    dashboard = Dashboard.find_by!(link_slug: params[:link_slug])
    if dashboard.published?
      if !dashboard.password.blank? && authenticated_for?(dashboard)
        pm = ProjectManager.new(dashboard.user)
        render 'projects/show', layout: 'simple', locals: {
          project: pm.find_project(dashboard.project_uid),
          deadlines: pm.deadlines_for(dashboard.project_uid),
        }
      else
        redirect_to login_dashboard_path(dashboard.link_slug)
      end
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

  def login
    render locals: {
      link_slug: params[:link_slug]
    }
  end

  def authenticate
    dashboard = Dashboard.find_by!(link_slug: params[:link_slug])
    if params[:dashboard_login][:password] == dashboard.password
      session[:authenticated_for] ||= Set.new
      session[:authenticated_for].add(dashboard.link_slug)
      render :show
    else
      redirect_to root_url, notice: t('notice.invalid_password')
    end
  end

  private

  def dashboard_params
    params.require(:dashboard)
      .permit(:password, :show_tasks, :published, :project_uid, :link_slug)
  end

  def authenticated_for? dashboard
    session[:authenticated_for].include?(dashboard.link_slug)
  end
end
