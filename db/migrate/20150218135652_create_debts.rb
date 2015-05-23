class CreateDebts < ActiveRecord::Migration
  def change
    create_table :debts do |t|
      t.integer :who_id
      t.integer :whom_id
      t.decimal :amount

      t.timestamps
    end

    add_index :debts, :who_id
    add_index :debts, :whom_id
  end
end
