class DeadlinesController < ApplicationController
  before_action :authenticate_user!

  def show
    project_uid = params[:project_id]
    deadline_uid = params[:id]
    page = DeadlinePage.new(
      deadline: pm.find_deadline(project_uid, deadline_uid),
      project: pm.find_project(project_uid),
      tasks: pm.tasks_for(project_uid, deadline_uid)
    )
    render layout: 'simple', locals: { page: page }
  end
end
