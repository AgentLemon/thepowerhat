class CreateSecuredMessages < ActiveRecord::Migration
  def change
    create_table :secured_messages do |t|
      t.text :encrypted_message
      t.string :salt
      t.integer :post_id

      t.timestamps
    end
  end
end
