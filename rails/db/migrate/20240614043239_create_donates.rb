class CreateDonates < ActiveRecord::Migration[7.1]
  def change
    create_table :donates do |t|
      t.string :nickname
      t.text :message
      t.float :value
      t.boolean :was_paid, default: false
      t.string :status

      t.timestamps
    end
  end
end
