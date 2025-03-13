class Tweet < ApplicationRecord
  belongs_to :user
  
  scope :newest, -> () { order(created_at: :desc) }
  scope :oldest, -> () { order(created_at: :asc) }
  scope :by_user, -> (username) { where(user_id: User.find_by(username: username)&.id) if username.present? }
end
