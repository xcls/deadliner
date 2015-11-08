class RenameProjectIdentifierToProjectUidInDashboards < ActiveRecord::Migration
  def change
    rename_column(:dashboards, :project_identifier, :project_uid)
  end
end
