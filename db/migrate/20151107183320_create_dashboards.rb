class CreateDashboards < ActiveRecord::Migration
  def change
    create_table :dashboards do |t|
      t.string :project_identifier
      t.references :user, index: true, foreign_key: true
      t.string :link_slug
      t.string :password
      t.boolean :show_tasks
      t.boolean :published

      t.timestamps null: false
    end
  end
end
