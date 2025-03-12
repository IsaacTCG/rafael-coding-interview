class User < ApplicationRecord
  belongs_to :company

  scope :by_company, -> (identifier) { where(company: identifier) if identifier.present? }
  scope :by_username, -> (username) { where('LOWER(display_name) LIKE LOWER(?)', "%#{username}%") if username.present? }
end
