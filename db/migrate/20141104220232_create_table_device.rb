class CreateTableDevice < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.date :date
      t.time :time
      t.boolean :male
      t.string :device
      t.integer :activity

      t.timestamps
    end

    add_index :devices, :date
    add_index :devices, :time
    add_index :devices, :male
    add_index :devices, :device
    add_index :devices, :activity
  end
end
