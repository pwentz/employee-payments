class Payee < ApplicationRecord
  belongs_to :employee
  has_many :payments

  validates :plaid_id, presence: true
  validates :account_number, presence: true
end
