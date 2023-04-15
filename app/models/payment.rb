class Payment < ApplicationRecord
  belongs_to :payor
  belongs_to :payee
  belongs_to :upload

  validates :amount, presence: true, numericality: { greater_than: 0.0, less_than: 1_000_000.0 }

  enum :status, {
    pending: 0,
    in_progress: 1,
    processed: 2,
    failed: 3,
    cancelled: 4
  }

  def self.payor_totals
    joins(:payor)
      .select("account_number, SUM(amount) as amount")
      .group("account_number")
  end
end
