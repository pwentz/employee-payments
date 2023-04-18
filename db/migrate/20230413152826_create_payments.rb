class CreatePayments < ActiveRecord::Migration[7.0]
  def change
    create_table :payments do |t|
      t.references :upload, null: false, foreign_key: true
      t.references :payee, null: false, foreign_key: true
      t.references :payor, null: false, foreign_key: true
      t.decimal :amount, null: false, precision: 9, scale: 2
      t.integer :status, default: 0, null: false
      t.string :methodfi_id, index: { unique: true }

      t.timestamps
    end
  end
end
