class Employee < ApplicationRecord
  has_many :payees

  validates :corporate_id, presence: true
  validates :branch_id, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :date_of_birth, presence: true
  validates :phone_number, presence: true
end
