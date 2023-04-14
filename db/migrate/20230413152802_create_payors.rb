class CreatePayors < ActiveRecord::Migration[7.0]
  def change
    create_table :payors do |t|
      t.string :corporate_id, null: false
      t.references :employer, null: false, foreign_key: true
      t.string :routing_number, null: false
      t.string :account_number, null: false
      t.string :methodfi_id

      t.timestamps
    end
  end
end
