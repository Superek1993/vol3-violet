class CreateBills < ActiveRecord::Migration[5.2]
  def change
    create_table :bills do |t|
      t.references :user, foreign_key: true
      t.decimal :amount, precision: 8, scale: 2, default: 0
      t.string :type
    end
  end
end
