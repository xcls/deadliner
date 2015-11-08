# == Schema Information
#
# Table name: users
#
#  id                 :integer          not null, primary key
#  email              :string           not null
#  provider           :string
#  uid                :string
#  sign_in_count      :integer          default(0), not null
#  current_sign_in_at :datetime
#  last_sign_in_at    :datetime
#  current_sign_in_ip :inet
#  last_sign_in_ip    :inet
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  github_token       :string
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # devise :database_authenticatable, :registerable,
  #        :recoverable, :rememberable, :trackable, :validatable
  devise :trackable, :omniauthable,
    omniauth_providers: [:github]

  has_many :dashboards

  class << self
    def from_omniauth(auth)
      user = where(provider: auth.provider, uid: auth.uid).first_or_create do |u|
        u.email = auth.info.email
      end
      # In case we changed the permissions we need to update the access token
      if auth.credentials.try(:token)
        user.update!(github_token: auth.credentials.token)
      else
        logger.error { "No github access token found #{user.email}" }
      end
      user
    end
  end
end
