class RenameLinkSlugToSlugInDashboards < ActiveRecord::Migration
  def change
    rename_column :dashboards, :link_slug, :slug
  end
end
