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
  validates_uniqueness_of :link_slug
  validates_format_of :link_slug, with: /\A[a-zA-Z0-9\-\_]+\z/, on: :update
  before_create :generate_link_slug

  alias_attribute :slug, :link_slug

  protected

  def generate_link_slug
    self.link_slug = loop do
      link_slug = SecureRandom.urlsafe_base64(nil, false)
      break link_slug unless Dashboard.exists?(link_slug: link_slug)
    end
  end
end
