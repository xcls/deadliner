# == Schema Information
#
# Table name: dashboards
#
#  id          :integer          not null, primary key
#  project_uid :string
#  user_id     :integer
#  link_slug   :string
#  password    :string
#  show_tasks  :boolean
#  published   :boolean
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Dashboard < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :user_id, :project_uid
  validates_uniqueness_of :project_uid, scope: :user_id
  before_create :generate_link_slug

  protected

  def generate_token
    self.token = loop do
      link_slug = SecureRandom.urlsafe_base64(nil, false)
      break link_slug unless Dashboard.exists?(link_slug: link_slug)
    end
  end
end
