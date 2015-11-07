class DeadlinesController < ApplicationController
  before_action :authenticate_user!

  def show
    render locals: {
      deadline: pm.find_deadline(params[:project_id], params[:id]),
      open_tasks: pm.open_tasks_for(params[:project_id], params[:id]),
      closed_tasks: pm.closed_tasks_for(params[:project_id], params[:id])
    }
  end
end
