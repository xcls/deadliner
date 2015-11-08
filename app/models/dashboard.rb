# == Schema Information
#
# Table name: dashboards
#
#  id                 :integer          not null, primary key
#  project_identifier :string
#  user_id            :integer
#  link_slug          :string
#  password           :string
#  show_tasks         :boolean
#  published          :boolean
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class Dashboard < ActiveRecord::Base
  belongs_to :user
  has_secure_token :link_slug
end
