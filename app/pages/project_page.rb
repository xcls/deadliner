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

  class InternalDashboard
    def show_issues?
      true
    end
  end
end
