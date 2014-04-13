class StaticcontentController < ApplicationController

  def home
    @events = Event.all
    @conflictingEvents = []
    
    @events.each do |e|
      potential = @events.select{|e2| e.users.include? current_user and e2.users.include? current_user and e2.startDate<=e.endDate and e.startDate<=e2.endDate}.uniq.sort
      if (potential.size > 1 and not @conflictingEvents.include? potential)
        @conflictingEvents << potential
      end
    end
    
  end
  
end
