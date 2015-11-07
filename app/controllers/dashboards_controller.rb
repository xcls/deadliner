class DashboardsController < ApplicationController
  before_action :authenticate_user!

  def new
    @dashboard = Dashboard.new
  end

  def create
    @dashboard = current_user.dashboard.create(dashboard_params)

    if @dashboard.save
      render :show
    else
      render :new
    end
  end

  private

  def dashboard_params
    params.require(:dashboard).permit(:password, :show_tasks, :published)
  end
end
