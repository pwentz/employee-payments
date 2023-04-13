class CreatePayors < ActiveRecord::Migration[7.0]
  def change
    create_table :payors do |t|
      t.string :corporate_id
      t.references :employer, null: false, foreign_key: true
      t.string :routing_number
      t.string :account_number

      t.timestamps
    end
  end
end
