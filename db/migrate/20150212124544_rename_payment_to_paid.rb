class RenamePaymentToPaid < ActiveRecord::Migration
  def change
    rename_column :party_members, :payment, :paid
  end
end
