class CreateEmployers < ActiveRecord::Migration[7.0]
  def change
    create_table :employers do |t|
      t.string :name, null: false
      t.string :dba
      t.string :ein_number, null: false, index: { unique: true }
      t.string :address_line_1, null: false
      t.string :address_line_2
      t.string :address_city, null: false
      t.string :address_state, null: false
      t.string :address_zip, null: false
      t.string :methodfi_id, index: { unique: true }

      t.timestamps
    end
  end
end
