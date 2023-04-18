class CreatePayors < ActiveRecord::Migration[7.0]
  def change
    create_table :payors do |t|
      t.string :corporate_id, null: false, index: { unique: true }
      t.references :employer, null: false, foreign_key: true
      t.string :routing_number, null: false
      t.string :account_number, null: false, index: { unique: true }
      t.string :methodfi_id, index: { unique: true }

      t.timestamps
    end
  end
end
