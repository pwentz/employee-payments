class Upload < ApplicationRecord
  has_many :payments

  enum :status, {
    pending: 0,
    in_progress: 1,
    processed: 2,
    failed: 3,
    discarded: 4
  }
end
