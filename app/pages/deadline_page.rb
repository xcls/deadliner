class DeadlinePage
  attr_reader :deadline, :project, :tasks,  :dashboard

  def initialize(project:, deadline:, tasks:,  dashboard: InternalDashboard.new)
    @project = project
    @deadline = deadline
    @tasks = tasks
    @dashboard = dashboard
  end

  def internal?
    !dashboard.is_a?(Dashboard)
  end

  def show_tasks?
    return true if internal?
    dashboard.show_tasks?
  end

  def link_to_project(view_context, project)
    path = path_for_project(view_context, project)
    view_context.link_to(path) { yield }
  end

  def path_for_project(view_context, project)
    if internal?
      view_context.project_path(
        id: project.full_name
      )
    else
      view_context.show_dashboard_path(
        slug: dashboard.slug
      )
    end
  end

  class InternalDashboard
    def show_issues?
      true
    end
  end
end
