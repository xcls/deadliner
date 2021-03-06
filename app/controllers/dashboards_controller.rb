class DashboardsController < ApplicationController
  before_action :authenticate_user!, except: [:show, :show_deadline, :login, :authenticate]

  def show
    dashboard = Dashboard.find_by!(slug: params[:slug])
    unless dashboard.published?
      return redirect_to root_url, alert: "Dashboard unavailable"
    end
    return unless basic_authenticate(dashboard)

    pm = ProjectManager.new(dashboard.user)
    page = ProjectPage.new(
      dashboard: dashboard,
      project: pm.find_project(dashboard.project_uid),
      deadlines: pm.deadlines_for(dashboard.project_uid)
    )
    render 'projects/show', layout: 'simple', locals: { page: page }
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
      render :edit, layout: 'simple', locals: {
        github_user: pm.github_user,
        dashboard: dashboard
      }
    end
  end

  def show_deadline
    dashboard = Dashboard.find_by!(slug: params[:slug])
    pm = ProjectManager.new(dashboard.user)
    page = DeadlinePage.new(
      dashboard: dashboard,
      deadline: pm.find_deadline(dashboard.project_uid, params[:id]),
      project: pm.find_project(dashboard.project_uid),
      tasks: pm.tasks_for(dashboard.project_uid, params[:id])
    )
    if page.show_tasks?
      render 'deadlines/show', layout: 'simple', locals: { page: page }
    else
      redirect_to show_dashboard_path(slug: dashboard.slug)
    end
  end

  def login
    render locals: { slug: params[:slug] }
  end

  private

  def dashboard_params
    params.require(:dashboard)
      .permit(:password, :show_tasks, :published, :project_uid, :slug)
  end

  def basic_authenticate(dashboard)
    return true if dashboard.password.blank?
    success = authenticate_with_http_basic { |uid, pass|
      dashboard.slug == uid && dashboard.password == pass
    }
    return true if success
    request_http_basic_authentication("The 'User Name' is #{dashboard.slug}")
    false
  end

  def user_and_pass
    ActionController::HttpAuthentication::Basic::user_name_and_password(request)
  end
end
