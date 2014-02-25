class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.string :description
      t.datetime :startDate
      t.datetime :endDate
      t.string :location
      t.references :users, index: true

      t.timestamps
    end
  end
end
