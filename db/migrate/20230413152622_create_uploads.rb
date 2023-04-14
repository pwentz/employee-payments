class CreateUploads < ActiveRecord::Migration[7.0]
  def change
    create_table :uploads do |t|
      t.integer :status, default: 0, null: false

      t.timestamps
    end
  end
end
