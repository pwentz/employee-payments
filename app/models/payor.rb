class Payor < ApplicationRecord
  belongs_to :employer
  has_many :payments

  validates :corporate_id, presence: true
  validates :routing_number, presence: true
  validates :account_number, presence: true
end
