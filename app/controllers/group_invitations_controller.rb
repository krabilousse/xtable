class GroupInvitationsController < ApplicationController
  before_action :set_group_invitation, only: [:show, :edit, :update, :destroy]
  before_action :set_group_invitation2, only: [:accept, :refuse]
  before_action :authenticate_user!
  before_action :check_is_admin, except: [:index, :accept, :refuse]
  before_action :check_is_owner, only: [:accept, :refuse]

  # GET /group_invitations
  # GET /group_invitations.json
  def index
    @group_invitations = GroupInvitation.where(user: current_user)
  end

  # GET /group_invitations/1
  # GET /group_invitations/1.json
  def show
  end

  # GET /group_invitations/new
  def new
    @group_invitation = GroupInvitation.new
  end

  # GET /group_invitations/1/edit
  def edit
  end

  # POST /group_invitations
  # POST /group_invitations.json
  def create
    @group_invitation = GroupInvitation.new(group_invitation_params)

    respond_to do |format|
      if @group_invitation.save
        format.html { redirect_to @group_invitation, notice: 'Group invitation was successfully created.' }
        format.json { render action: 'show', status: :created, location: @group_invitation }
      else
        format.html { render action: 'new' }
        format.json { render json: @group_invitation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /group_invitations/1
  # PATCH/PUT /group_invitations/1.json
  def update
    respond_to do |format|
      if @group_invitation.update(group_invitation_params)
        format.html { redirect_to @group_invitation, notice: 'Group invitation was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @group_invitation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /group_invitations/1
  # DELETE /group_invitations/1.json
  def destroy
    @group_invitation.destroy
    respond_to do |format|
      format.html { redirect_to group_invitations_url }
      format.json { head :no_content }
    end
  end    
  
  def accept
    msg = ""
    group = @group_invitation.group
    begin      
      if group.add_follower(current_user)
        @group_invitation.destroy
        msg = 'Invitation accepted'      
      else
        msg = 'Failed to validate invitation'
      end      
    rescue
      msg = 'Failed to validate invitation'
    ensure
      redirect_to group_invitations_path, notice: msg
    end    
  end
  
  def refuse
    msg = ""
    begin                  
      @group_invitation.destroy      
      msg = 'Invitation refused'
    rescue
      msg = 'Failed to refuse invitation'
    ensure
      redirect_to group_invitations_path, notice: msg
    end 
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group_invitation
      @group_invitation = GroupInvitation.find(params[:id])
    end
    
    def set_group_invitation2
      @group_invitation = GroupInvitation.find(params[:group_invitation_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def group_invitation_params
      params.require(:group_invitation).permit(:group_id, :user_id)
    end
    
    def check_is_admin
      unless @group_invitation.group.is_admin(current_user)
        redirect_to group_invitations_path, notice: 'Permission denied, you are not an admin of the requested group'        
      end
    end
    
    def check_is_owner
      unless @group_invitation.is_owner(current_user)
        redirect_to group_invitations_path, notice: 'Permission denied, you dont own this invitation'        
      end
    end
end
