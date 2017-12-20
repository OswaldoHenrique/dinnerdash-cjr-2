class Meal < ApplicationRecord
  belongs_to :meal_category
  validates :title, :description, :price, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  validates :available, inclusion: { in: [false, true] }
  validates :available, exclusion: { in: [nil] }
end
