class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  before_action :checkIsAdmin, except: [:show, :index, :create, :new, :search, :subscribe, :unsubscribe]
  # before_filter :authenticate_user!
  # GET /groups
  # GET /groups.json
  def index
    @emptySearch=Group.new
    @groups = Group.where(isPrivate: false).paginate(page: params[:page])
  end

  # GET /groups/1
  # GET /groups/1.json
  def show
    @group = Group.find(params[:id])
    @events = @group.events
    @users = @group.users
    @followers = @users
    @users_to_invite = User.all.select('id, name')
    @group_invitation = GroupInvitation.new
    @group_invitation.group = @group
    
    @admin = @group.get_admin
    
    #calendar stuff
    startD = Time.at(params[:start].to_f).to_datetime
    endD = Time.at(params[:end].to_f).to_datetime
  
    respond_to do |format|
      format.json {
        render json: @events
        .where(:startDate => startD.to_time..endD.to_time)
        }
      format.html { render :action => 'show'}
    end
  end

  # GET /groups/new
  def new
    @group = Group.new
  end

  # GET /groups/1/edit
  def edit
    @group = Group.find(params[:id])
  end

  # POST /groups
  # POST /groups.json
  def create
    @group = Group.new(group_params)

    respond_to do |format|
      if @group.save && @group.add_admin(current_user)
        format.html { redirect_to @group, notice: 'Group was successfully created.' }
        format.json { render action: 'show', status: :created, location: @group }
      else
        format.html { render action: 'new' , notice: 'Failed to create group.'}
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /groups/1
  # PATCH/PUT /groups/1.json
  def update
    respond_to do |format|
      if @group.update(group_params)
        format.html { redirect_to @group, notice: 'Group was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.json
  def destroy
    @group.destroy
    respond_to do |format|
      format.html { redirect_to groups_url }
      format.json { head :no_content }
    end
  end
  
  def search
    @emptySearch=Group.new
    @search=Group.where("name LIKE :keyword OR description LIKE :keyword", :keyword => "%#{group_params[:name]}%").paginate(page: params[:page])  
  end
  
  def subscribe
    @group = Group.find(params[:group_id])    
    begin
    @group.add_follower(current_user)
    if @group.save
      redirect_to @group, notice: 'Subscription ok'
    else
      redirect_to @group, notice: 'Subscription problem'
    end
    rescue
      redirect_to @group, notice: 'Subscription problem'
    end
  end
  
  def unsubscribe
    @group = Group.find(params[:group_id])
    @group.users.delete(current_user)
    redirect_to @group, notice: 'Unsubscription ok'
  end
  
  def checkIsAdmin
    @group.is_admin?(current_user)
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = Group.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def group_params
      params.require(:group).permit(:name, :description, :isPrivate)
    end
end
