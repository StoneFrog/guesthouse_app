class CreateReservations < ActiveRecord::Migration
  def change
    create_table :reservations do |t|
      t.string :name
      t.string :surname
      t.string :email
      t.string :phone
      t.string :room
      t.boolean :confirmation, default: false
      t.datetime :checkin
      t.datetime :checkout
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
