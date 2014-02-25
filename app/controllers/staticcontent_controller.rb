class StaticcontentController < ApplicationController
  before_filter :authenticate_user!, only: [:private_content]
    
  def home
    
  end
  
  def private_content
    
  end
end
