class CreatePayees < ActiveRecord::Migration[7.0]
  def change
    create_table :payees do |t|
      t.references :employee, null: false, foreign_key: true
      t.string :plaid_id, null: false
      t.string :account_number, null: false
      t.string :methodfi_id

      t.timestamps
    end
  end
end
