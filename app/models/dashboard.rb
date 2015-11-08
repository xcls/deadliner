# == Schema Information
#
# Table name: dashboards
#
#  id          :integer          not null, primary key
#  project_uid :string
#  user_id     :integer
#  slug        :string
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
  validates_uniqueness_of :slug
  validates_format_of :slug, with: /\A[a-zA-Z0-9\-_]+\z/
  before_create :generate_slug

  protected

  def generate_slug
    self.slug = loop do
      val = SecureRandom.urlsafe_base64(nil, false)
      break val unless Dashboard.exists?(slug: val)
    end
  end
end
