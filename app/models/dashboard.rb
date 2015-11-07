class Dashboard < ActiveRecord::Base
  belongs_to :user
  has_secure_token :link_slug
end
