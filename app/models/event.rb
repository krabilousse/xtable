class Event < ActiveRecord::Base
  has_and_belongs_to_many :users, -> { uniq }
  belongs_to :group  
  def as_json options={}
    {id:id, title: name, start:startDate, end:endDate, allDay:false}
  end
  
  def get_participants
    self.users
  end
  
  self.per_page = 10
end
