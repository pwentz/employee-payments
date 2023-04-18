class CreateEmployees < ActiveRecord::Migration[7.0]
  def change
    create_table :employees do |t|
      t.string :corporate_id, null: false, index: { unique: true }
      t.string :branch_id, null: false
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.date :date_of_birth, null: false
      t.string :phone_number, null: false
      t.string :methodfi_id, index: { unique: true }

      t.timestamps
    end
  end
end
