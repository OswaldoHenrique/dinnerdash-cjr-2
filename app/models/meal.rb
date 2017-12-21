class Meal < ApplicationRecord
  belongs_to :meal_category
  validates :name, :description, :price, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  validates :available, inclusion: { in: [false, true] }
  validates :available, exclusion: { in: [nil] }
  has_many :order_has_meals
end
