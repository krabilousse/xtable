class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!
  # GET /events
  # GET /events.json
  def index
    @emptySearch=Event.new
    @events = Event.all
    @paginated_events = Event.all.paginate(page: params[:page])
    startD = Time.at(params[:start].to_f).to_datetime
    endD = Time.at(params[:end].to_f).to_datetime
  
    respond_to do |format|
      format.json {
        render json: @events
        .where(:startDate => startD.to_time..endD.to_time)
        .select{|e| e.users.include? current_user}
        }
      format.html { render :action => "index"}
    end
  end

  # GET /events/1
  # GET /events/1.json
  def show
    @event = Event.find(params[:id])
    @group = Group.find(@event.group_id)
    @participants = @event.users
  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(event_params)
    
    @event.users << current_user
    
    @event.group = Group.find(event_params[:group_id])

    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: 'Event was successfully created.' }
        format.json { render action: 'show', status: :created, location: @event }
      else
        format.html { render action: 'new' }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url }
      format.json { head :no_content }
    end
  end
  
  def search
    @emptySearch=Event.new
    @search=Event.where("name LIKE :keyword OR description LIKE :keyword", :keyword => "%#{event_params[:name]}%").paginate(page: params[:page])  
  end
  
  def participate
    @event = Event.find(params[:event_id])
    
    begin
    @event.users << current_user
    if @event.save and not @event.users.include? current_user
      redirect_to @event, notice: 'Participation ok !'
    else
      redirect_to @event, notice: 'Participation problem'
    end
    rescue
      redirect_to @event, notice: 'Participation problem'
    end
  end
  
  def unparticipate
    @event = Event.find(params[:event_id])
    begin
      @event.users.delete(current_user)
      redirect_to @event, notice: 'Not participating anymore!'
    rescue
      redirect_to @event, notice: 'Problem while unparticipating!'
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params.require(:event).permit(:name, :description, :startDate, :endDate, :location, :page, :format,:group_id)
    end
end
