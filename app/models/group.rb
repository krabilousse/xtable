class Group < ActiveRecord::Base
  belongs_to :events
  belongs_to :tags
end
