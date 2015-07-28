class FeedGamesController < ApplicationController
  before_action :set_feed_game, only: [:show, :edit, :update, :destroy]

  # GET /feed_games
  # GET /feed_games.json
  def index
    @feed_games = FeedGame.all
  end

  # GET /feed_games/1
  # GET /feed_games/1.json
  def show
  end

  # GET /feed_games/new
  def new
    @feed_game = FeedGame.new
  end

  # GET /feed_games/1/edit
  def edit
  end

  # POST /feed_games
  # POST /feed_games.json
  def create
    @feed_game = FeedGame.new(feed_game_params)

    respond_to do |format|
      if @feed_game.save
        format.html { redirect_to @feed_game, notice: 'Feed game was successfully created.' }
        format.json { render action: 'show', status: :created, location: @feed_game }
      else
        format.html { render action: 'new' }
        format.json { render json: @feed_game.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /feed_games/1
  # PATCH/PUT /feed_games/1.json
  def update
    respond_to do |format|
      if @feed_game.update(feed_game_params)
        format.html { redirect_to @feed_game, notice: 'Feed game was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @feed_game.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /feed_games/1
  # DELETE /feed_games/1.json
  def destroy
    @feed_game.destroy
    respond_to do |format|
      format.html { redirect_to feed_games_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_feed_game
      @feed_game = FeedGame.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def feed_game_params
      params.require(:feed_game).permit(:name, :description, :thumb_60, :thumb_120, :thumb_180, :external_link, :orientation, :game_added, :aspect_ratio)
    end
end
