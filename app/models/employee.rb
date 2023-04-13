class Employee < ApplicationRecord
  has_many :payments

  validates :corporate_id, presence: true
  validates :branch_id, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  # TODO: come back to this
  validates :date_of_birth, presence: true
  validates :phone_number, presence: true
  validates :plaid_id, presence: true
  validates :account_number, presence: true
end
