class DashboardsController < ApplicationController
  before_action :authenticate_user!, except: [:show, :login, :authenticate]

  def show
    dashboard = Dashboard.find_by!(slug: params[:slug])

    unless dashboard.published?
      return redirect_to root_url, notice: "Dashboard unavailable"
    end

    if authenticated_for?(dashboard)
      pm = ProjectManager.new(dashboard.user)
      render 'projects/show', layout: 'simple', locals: {
        project: pm.find_project(dashboard.project_uid),
        deadlines: pm.deadlines_for(dashboard.project_uid),
      }
    else
      redirect_to login_dashboard_path(dashboard.slug)
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
    dashboard = Dashboard.find_by!(slug: params[:slug])
    pm = ProjectManager.new(dashboard.user)
    render locals: {
      deadline: pm.find_deadline(params[:project_id], params[:id]),
      tasks: pm.tasks_for(params[:project_id], params[:id])
    }
  end

  def login
    render locals: { slug: params[:slug] }
  end

  def authenticate
    dashboard = Dashboard.find_by!(slug: params[:slug])
    if params[:dashboard_login][:password] == dashboard.password
      session[:authenticated_for] ||= Set.new
      session[:authenticated_for].add(dashboard.slug)
      redirect_to show_dashboard_path(dashboard.slug)
    else
      redirect_to root_url, notice: t('notice.invalid_password')
    end
  end

  private

  def dashboard_params
    params.require(:dashboard)
      .permit(:password, :show_tasks, :published, :project_uid, :slug)
  end

  def authenticated_for?(dashboard)
    return true if dashboard.password.blank?
    (session[:authenticated_for] || []).include?(dashboard.slug)
  end
end
