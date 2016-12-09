class Api::BroadcastsController < API::ApplicationController # TODO naming
  
  before_action :set_broadcast, only: [:show, :destroy]
  rescue_from ActiveRecord::RecordNotFound, with: :squelch_record_not_found
  
  # This is an admin specific controller, so enforce access by admin only
  # This is a very simple form of authorisation
  before_action :admin_required

  # GET /broadcasts.json
  def index
    @broadcasts = Broadcast.all
  end

  # GET /broadcasts/1.json
  def show
  end

  # POST /broadcasts.json
  def create
    @broadcast = Broadcast.new(broadcast_params)

    # Wire up broadcast with the current user (an administrator)
    # Will be an admin user (see before_action)
    # Note the current_user is a user_detail object so we need
    # to navigate to its user object
    @broadcast.user = current_user.user

    # Doing the next line forces a save automatically. I want to defer this
    # until the "if" statement
    #current_user.user.broadcasts << @broadcast

    no_errors = false
    respond_to do |format|
      if @broadcast.save

        # Only after saving do we try and do the real broadcast. Could have been
        # done using an observer, but I wanted this to be more explicit

        results = BroadcastService.broadcast(@broadcast, params[:feeds])
        if results.length > 0
          # Something went wrong when trying to broadcast to one or more of the
          # feeds.
          @broadcast.errors[:base] << ("#{I18n.t('broadcasts.unable-message')}: #{results.inspect}")
        else
          no_errors = true
        end
        if no_errors
          format.json { render json: @broadcast, status: :created, location: @broadcast }
        else
          format.json {
            # Either say it partly worked but send back the errors or else send
            # back complete failure indicator (couldn't even save)
            if results
              render json: @broadcast.errors, status: :created, location: @broadcast
            else
              render json: @broadcast.errors, status: :unprocessable_entity
            end
          }
        end
      end
    end
  end

  # DELETE /broadcasts/1.json
  def destroy
    @broadcast.destroy
    respond_to do |format|
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_broadcast
    @broadcast = Broadcast.find(params[:id])
  end

  def set_current_page
    @current_page = params[:page] || 1
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def broadcast_params
    params.require(:broadcast).permit(:content)
  end

  def squelch_record_not_found(exception)
    respond_to do |format|
      format.json { head :no_content }
    end
  end
end
