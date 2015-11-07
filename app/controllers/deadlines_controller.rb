class DeadlinesController < ApplicationController
  before_action :authenticate_user!

  def show
    render locals: {
      deadline: pm.find_deadline(params[:project_id], params[:id]),
      tasks: pm.tasks_for(params[:project_id], params[:id])
    }
  end
end
