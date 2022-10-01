class Listing < ApplicationRecord
  belongs_to :host, class_name: 'User'
  validates :title, presence: true
  enum status: [:draft, :published, :archived]
  validates :max_guests, numericality: {greater_than: 0, less_than: 100 }
end
