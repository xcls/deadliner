class ProjectPage
  attr_reader :project, :deadlines, :dashboard

  def initialize(project:, deadlines:, dashboard: InternalDashboard.new)
    @project = project
    @deadlines = deadlines || []
    @dashboard = dashboard
  end

  def internal?
    !dashboard.is_a?(Dashboard)
  end

  def show_tasks?
    return true if internal?
    dashboard.show_tasks?
  end

  def link_to_deadline(view_context, deadline)
    if show_tasks?
      path = path_for_deadline(view_context, deadline)
      view_context.link_to(path) { yield }
    else
      view_context.content_tag(:a) { yield }
    end
  end

  def featured_deadline
    deadlines && deadlines.first
  end

  def path_for_deadline(view_context, deadline)
    return '' unless show_tasks?
    view_context.deadline_path(
      project_id: project.full_name,
      id: deadline.number
    )
  end

  class InternalDashboard
    def show_issues?
      true
    end
  end
end
