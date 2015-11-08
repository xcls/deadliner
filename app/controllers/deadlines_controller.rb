class DeadlinesController < ApplicationController
  before_action :authenticate_user!

  def show
    project_uid = params[:project_id]
    deadline_uid = params[:id]
    render layout: 'simple', locals: {
      project: pm.find_project(project_uid),
      deadline: pm.find_deadline(project_uid, deadline_uid),
      tasks: pm.tasks_for(project_uid, deadline_uid)
    }
  end
end
