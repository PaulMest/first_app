class CreatePurchaseOrders < ActiveRecord::Migration
  def change
    create_table :purchase_orders do |t|
    	t.string "po_number"
        t.timestamps
    end
  end
end
