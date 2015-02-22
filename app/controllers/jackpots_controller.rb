class JackpotsController < ApplicationController
  before_action :set_jackpot, only: [:show, :edit, :update, :destroy]

  # GET /jackpots
  # GET /jackpots.json
  def index
    @jackpots = Jackpot.all
  end

  # GET /jackpots/1
  # GET /jackpots/1.json
  def show
    @message = nil
    if current_user && signed_in? && params[:credits] && params[:id] && !params[:credits].blank?
      count = 0
      if current_user.credits >= params[:credits].to_i
        params[:credits].to_i.times do | e | 
          if @jackpot.user_entries.size < @jackpot.max_entries 
            user_entry = UserEntry.new
            user_entry.user_id = current_user.id
            user_entry.jackpot_id = @jackpot.id
            if user_entry.save
              count = count + 1
              current_user.credits = (current_user.credits - 1) 
              current_user.save(validate: false)
              @message = "You have deposited #{params[:credits]} credits into the pot!"
            end
          else
            @message = "The jackpot has filled up with entries.  #{count} of the #{params[:credits]} credits you deposited made it in."
          end
        end
      else
        @message = "You cannot deposit #{params[:credits]} credits! You only have #{current_user.credits} credits."
      end
    end
  end

  # GET /jackpots/new
  def new
    @jackpot = Jackpot.new
  end

  # GET /jackpots/1/edit
  def edit
  end

  # POST /jackpots
  # POST /jackpots.json
  def create
    @jackpot = Jackpot.new(jackpot_params)

    respond_to do |format|
      if @jackpot.save
        format.html { redirect_to @jackpot, notice: 'Jackpot was successfully created.' }
        format.json { render action: 'show', status: :created, location: @jackpot }
      else
        format.html { render action: 'new' }
        format.json { render json: @jackpot.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /jackpots/1
  # PATCH/PUT /jackpots/1.json
  def update
    respond_to do |format|
      if @jackpot.update(jackpot_params)
        format.html { redirect_to @jackpot, notice: 'Jackpot was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @jackpot.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /jackpots/1
  # DELETE /jackpots/1.json
  def destroy
    @jackpot.destroy
    respond_to do |format|
      format.html { redirect_to jackpots_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_jackpot
      @jackpot = Jackpot.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def jackpot_params
      params.require(:jackpot).permit(:name,:max_entries,:open,:draw_date,:winner_id,:prize)
    end
end
