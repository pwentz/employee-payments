class Employer < ApplicationRecord
  has_many :payors

  validates :name, presence: true
  validates :ein_number, presence: true
  validates :address_line_1, presence: true
  validates :address_city, presence: true
  validates :address_state, presence: true
  validates :address_zip, presence: true
end
