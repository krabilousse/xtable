class Event < ActiveRecord::Base
  has_and_belongs_to_many :users
  belongs_to :group
  
  def as_json options={}
    {id:id, title: name, start:startDate, end:endDate, color:"red"}
  end
  
end
