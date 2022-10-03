class Listing < ApplicationRecord
  belongs_to :host, class_name: 'User'
  has_many :rooms
  has_many :photos

  validates :title, presence: true
  enum status: [:draft, :published, :archived]
  validates :max_guests, numericality: {greater_than: 0, less_than: 100 }

  scope :with_published, -> { where(status: :published)}

end
