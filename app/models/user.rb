class User < ApplicationRecord
  belongs_to :company

  scope :by_company, -> (identifier) { where(company: identifier) if identifier.present? }
  scope :by_username, -> (username) { where('display_name LIKE ?', "%#{username}%") if username.present? }
end
