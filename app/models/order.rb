class Order < ApplicationRecord
  belongs_to :user
  validates :status, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0, allow_nil: true }
  validates :status, numericality: { greater_than_or_equal_to: 0,
                                    less_than_or_equal_to: 4,
                                    only_integer: true}
  has_many :order_has_meals
end
