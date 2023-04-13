class Payment < ApplicationRecord
  belongs_to :payor
  belongs_to :employee
  belongs_to :upload

  validates :amount, presence: true, numericality: { greater_than: 0.0, less_than: 1_000_000.0 }
end
