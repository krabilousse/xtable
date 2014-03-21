class RemoveEventsFromGroup < ActiveRecord::Migration
  def change
    remove_reference :groups,:events
  end
end
