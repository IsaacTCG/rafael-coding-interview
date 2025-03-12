class Tweet < ApplicationRecord
  belongs_to :user
  
  scope :newest, -> () { order(created_at: :desc) }
  scope :oldest, -> () { order(created_at: :asc) }
  scope :by_index, -> (last_index_to_get, current_index) { where("id >= ?", last_index_to_get) if current_index.present? && current_index.positive? }
end
