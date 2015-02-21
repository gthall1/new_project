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
