class CreateParties < ActiveRecord::Migration
  def change
    create_table :parties do |t|
      t.string :title
      t.datetime :date
      t.integer :leader_id

      t.timestamps
    end
  end
end
