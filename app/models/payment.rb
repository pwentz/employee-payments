class Payment < ApplicationRecord
  belongs_to :payor
  belongs_to :payee
  belongs_to :upload

  validates :amount, presence: true, numericality: { greater_than: 0.0, less_than: 1_000_000.0 }

  enum :status, {
    pending: 0,
    processing: 1,
    sent: 2,
    failed: 3,
    canceled: 4,
    invalidated: 5
  }

  def self.payor_totals
    joins(:payor)
      .select("account_number, SUM(amount) as amount")
      .group("account_number")
  end

  def self.branch_totals
    joins(payee: :employee)
      .select("branch_id, SUM(amount) as amount")
      .group("branch_id")
  end
end
