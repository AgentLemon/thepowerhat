class CreateBudget < ActiveRecord::Migration
  def change
    create_table :budget do |t|
      t.integer :user_id
      t.decimal :amount
      t.string :comment
      t.date :date

      t.timestamps
    end
  end
end
