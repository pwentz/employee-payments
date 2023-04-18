class CreatePayees < ActiveRecord::Migration[7.0]
  def change
    create_table :payees do |t|
      t.references :employee, null: false, foreign_key: true
      t.string :plaid_id, null: false
      t.string :account_number, null: false, index: { unique: true }
      t.string :methodfi_id, index: { unique: true }

      t.timestamps
    end
  end
end
