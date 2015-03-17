class GamesController < ApplicationController
  before_action :set_game, only: [:show, :edit, :update, :destroy]

  # GET /games
  # GET /games.json
  def index
    @games = Game.all
  end

  # GET /games/1
  # GET /games/1.json
  def show
    init_testgame(@game.id)
  end
  
  def test_game_check
    earned_credits = 0
    status = "failed"
    if params[:button] && params[:button] == "play" && params[:token] && !params[:token].empty?
      status = "success"
      
      game = UserGameSession.where(token: params[:token]).first
      #dont want people trying to spam old games
      if game.active
        win = rand(5) == 1
      else
        win = false
        status = "closed"
      end

      #10% chance of showing a random advertisement
      if rand(10) == 0
        if rand(2) == 0
          ad_image = "/assets/testad.jpg"
        else
          ad_image = "/assets/testad2.jpg"
        end
      else
        ad_image = "none"
      end

      if win 
        user = User.find(game.user_id)
        if user.credits.nil?
          user.credits = 1
          if user.save(validate: false)
            game.credits_earned = 0 if game.credits_earned.nil?
            game.credits_earned = game.credits_earned + 1
            game.save
          end
        else
          user.credits = user.credits + 1
          if user.save(validate: false)
            game.credits_earned = 0 if game.credits_earned.nil?
            game.credits_earned = game.credits_earned + 1
            game.save
          end
        end
      end
      earned_credits = game.credits_earned
    end

    game_json = {
      :win => win,
      :total_credits => earned_credits,
      :status => status,
      :partner_image => ad_image
    }

    render json: game_json
  end
  
  #returns 10 advertisers, for card game
  def get_advertisers
   # @advertisers = Advertiser.all.select(:id).limit(10)
   ad_json = {
      :advertisers => Advertiser.all.select(:id).limit(10).pluck(:id) 
    }
    render json: ad_json
  end

  def get_advertiser_logo
    ad_image = "testad2.jpg"
    if params[:id] && !params[:id].blank?
      ad_image =  Advertiser.find(params[:id]).logo      
    end
    ad_json = {
      :ad_image => ad_image
    }
    render json: ad_json
  end

  def memory_check
    earned_credits = 0
    total_earned_credits = 0
    win = false
    status = "failed"
    if params[:match] && params[:token] && !params[:token].empty?
      status = "success"
      
      game = UserGameSession.where(token: params[:token]).first

      if params[:match].to_i >= 10 
        win = true
        user = User.find(game.user_id)
        earned_credits = 10
        if user.credits.nil?
          user.credits = earned_credits
          if user.save(validate: false)
            game.credits_earned = 0 if game.credits_earned.nil?
            game.credits_earned = game.credits_earned + earned_credits
            game.save
          end
        else
          user.credits = user.credits + earned_credits
          if user.save(validate: false)
            game.credits_earned = 0 if game.credits_earned.nil?
            game.credits_earned = game.credits_earned + earned_credits
            game.save
          end
        end
      end
      total_earned_credits = game.credits_earned
    end

    game_json = {
      :win => win,  
      :earned => earned_credits,
      :total_credits => total_earned_credits,
      :status => status
    }

    render json: game_json
  end

  def helicopter_check
    earned_credits = 0
    total_earned_credits = 0
    win = false
    status = "failed"
    if params[:score] && params[:token] && !params[:token].empty?
      status = "success"
      
      game = UserGameSession.where(token: params[:token]).first
      score = params[:score].to_i
      if rand(2) == 0
        ad_image = "/assets/testad.jpg"
      else
        ad_image = "/assets/testad2.jpg"
      end

      if score >= 100 
        win = true
        user = User.find(game.user_id)
        earned_credits = score/100
        if user.credits.nil?
          user.credits = earned_credits
          if user.save(validate: false)
            game.credits_earned = 0 if game.credits_earned.nil?
            game.credits_earned = game.credits_earned + earned_credits
            game.save
          end
        else
          user.credits = user.credits + earned_credits
          if user.save(validate: false)
            game.credits_earned = 0 if game.credits_earned.nil?
            game.credits_earned = game.credits_earned + earned_credits
            game.save
          end
        end
      end
      total_earned_credits = game.credits_earned
    end

    game_json = {
      :win => win,  
      :earned => earned_credits,
      :total_credits => total_earned_credits,
      :status => status,
      :partner_image => ad_image
    }

    render json: game_json
  end
  # GET /games/new
  def new
    @game = Game.new
  end

  # GET /games/1/edit
  def edit
  end

  # POST /games
  # POST /games.json
  def create
    @game = Game.new(game_params)

    respond_to do |format|
      if @game.save
        format.html { redirect_to @game, notice: 'Game was successfully created.' }
        format.json { render action: 'show', status: :created, location: @game }
      else
        format.html { render action: 'new' }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /games/1
  # PATCH/PUT /games/1.json
  def update
    respond_to do |format|
      if @game.update(game_params)
        format.html { redirect_to @game, notice: 'Game was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /games/1
  # DELETE /games/1.json
  def destroy
    @game.destroy
    respond_to do |format|
      format.html { redirect_to games_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_game
      @game = Game.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def game_params
      params.require(:game).permit(:name)
    end

    def init_testgame(game_id)
      if signed_in?
        game = UserGameSession.new
        game.token = SecureRandom.urlsafe_base64
        game.user_id = current_user.id
        game.game_id = game_id
        game.credits_earned = 0
        game.active = true
        game.save
        if !session[:game_token].nil?
         old_game = UserGameSession.where(token:session[:game_token]).first
         #close previous game game
         if old_game
          old_game.active = false
          old_game.save
         end
        end 
        session[:game_token] = game.token   
      else
        redirect_to root_path
      end
    end      
end
