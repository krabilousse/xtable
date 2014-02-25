class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :name
      t.references :events, index: true
      t.references :tags, index: true
      t.string :description

      t.timestamps
    end
  end
end
