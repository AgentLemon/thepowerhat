class CreatePartyMembers < ActiveRecord::Migration
  def change
    create_table :party_members do |t|
      t.integer :user_id
      t.integer :party_id
      t.decimal :debt
      t.decimal :payment

      t.timestamps
    end

    add_index :party_members, :user_id
    add_index :party_members, :party_id
  end
end
