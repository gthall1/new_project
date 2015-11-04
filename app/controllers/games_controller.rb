class GamesController < ApplicationController
  before_action :set_game, only: [:show, :edit, :update, :destroy]
  before_filter :check_signed_in
  skip_before_filter  :verify_authenticity_token, only:[:score_update,:reset_game]
  include ApplicationHelper
  layout :determine_layout

  # GET /games
  # GET /games.json
  def index
    @games = Game.all
    @current_jackpot = Jackpot.where(open: true).first

    render "games/index_mobile" if is_mobile?
  end

  def check_signed_in
    redirect_to root_path if !signed_in?
  end
 
  # GET /games/1
  # GET /games/1.json
  def show
    @show_back_button = true
    case @game.name
      when "Memory Game"
        @top_scores = UserGameSession.where(game_id:@game.id).where.not(score:nil).order("score asc").limit(10)
      when "Helicopter"
        @top_scores = UserGameSession.where(game_id:@game.id).where.not(score:nil).order("score desc").limit(10)
      when "Sorcerer Game","2048","Black Hole","Traffic","Flappy Pilot"
        set_game_token({game_name:@game.name})
    end

    @current_high_score = UserGameSession.where(user_id:current_user.id,game_id:@game.id).where.not(score: nil).order("score desc").first.score if UserGameSession.where(user_id:current_user.id,game_id:@game.id).where.not(score: nil).order("score desc").present?
    @current_high_score = Time.at(@current_high_score).utc.strftime("%M:%S") if @current_high_score && @game.name == "Memory Game"


    render "games/show_mobile" if is_mobile?
  end
  
  def score_update
    status='fail'
    credits = 0
    user = current_user
    if params[:token] && !params[:token].empty? && params[:score] && !params[:score].empty?
      status = "success"
      score = params[:score].to_i
      game_session = UserGameSession.where(token: params[:token]).first
     # p "Score : #{score} | Game SEssion Score: #{game_session.score}"    
      if game_session.active
         credits_to_apply = get_credits_to_apply(game_session.game.name,score,game_session.credits_applied)
        if user && credits_to_apply > 0
          user.add_credits({credits:credits_to_apply}) 
          game_session.credits_applied += credits_to_apply 
        elsif !user
          status = "error"
        else
          status = "nothingearned"
        end
        game_session.score = score
        game_session.credits_earned += credits_to_apply 
        game_session.save
      # elsif score < game_session.score && credits < game_session.credits_applied
      #   #this is case when user starts new game and didnt get a new token
      #   set_game_token({game_name:game_session.game.name})
      #   game_session = UserGameSession.where(token: session[:game_token]).first
      #   game_session.score = score
      #   credits_to_apply = credits - game_session.credits_applied
      #   current_user.add_credits({credits:credits_to_apply})
      #   game_session.credits_earned = credits
      #   game_session.save
      elsif !game_session.active 

        status = "closed"
      else 
        status = "skip"
      end
      if UserGameSession.where(user_id:current_user.id,game_id:game_session.game.id).where.not(score: nil).order("score desc").present?
        current_high_score = UserGameSession.where(user_id:current_user.id,game_id:game_session.game.id).where.not(score: nil).order("score desc").first.score 
      else
        current_high_score = 0
      end
    elsif params[:score] && !params[:score].empty?
      if request && request.referer
        game_id = request.referer.split('/').last.to_i
      end
      create_new_game_session(params[:score],game_id) 
      game_session = UserGameSession.where(token: session[:game_token]).first     
    end

    case game_session.game.name
      when '2048','Black Hole','Sorcerer Game'
        game_json = {
           :earned => game_session.credits_earned,
           :total_credits => user.credits,
           :token => session[:game_token],
           :status => status,
           :hscore => current_high_score   
          }      
      when 'Flappy Pilot','Traffic'
        if game_session.game.slug == 'flappy-pilot'
          current_high_score = current_high_score.to_s.rjust(3, '0')
        end
        game_json = {
          :c2dictionary => true,
          :data => { 
           :earned => game_session.credits_earned,
           :total_credits => user.credits,
           :token => session[:game_token],
           :status => status,
           :hscore => current_high_score   
          }
        }
    end

    #render text: user.credits
    render json: game_json    
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
    high_score = nil
    status = "failed"
    total_time = nil
    score = params[:time_left]
    if score
      minutes = score.split(":")[0].to_i * 60
      seconds = score.split(":")[1].to_i
      total_time = minutes + seconds
      p total_time
    end
    if params[:match] && params[:token] && !params[:token].empty?
      status = "success"
 
      game = UserGameSession.where(token: params[:token]).first
      current_high_score = UserGameSession.where(user_id:current_user.id,game_id:game.game_id).where.not(score: nil).order("score desc").first
      current_high_score = Time.at(current_high_score.score).utc.strftime("%M:%S") if current_high_score     
      if params[:match].to_i >= 10 
        win = true
        user = User.find(game.user_id)
        earned_credits = 10
        if user.credits.nil?
          user.credits = earned_credits
          if user.save(validate: false)
            game.credits_earned = 0 if game.credits_earned.nil?
            game.credits_earned = game.credits_earned + earned_credits
            game.score = total_time
            game.save
          end
        else
          user.credits = user.credits + earned_credits
          if user.save(validate: false)
            game.credits_earned = 0 if game.credits_earned.nil?
            game.credits_earned = game.credits_earned + earned_credits
            game.score = total_time
            game.save
          end
        end
      end
      game_score = Time.at(game.score).utc.strftime("%M:%S")
      if current_high_score && game_score < current_high_score
        high_score = game_score
      elsif !current_high_score
        high_score = game_score
      end
      total_earned_credits = game.credits_earned
    end

    game_json = {
      :win => win,  
      :earned => earned_credits,
      :total_credits => total_earned_credits,
      :score => high_score,
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
      current_high_score = UserGameSession.where(user_id:current_user.id,game_id:game.game_id).where.not(score: nil).order("score desc").first
      if !current_high_score.blank?
        current_high_score = current_high_score.score
      else 
        current_high_score = nil
      end
      score = params[:score].to_i
      high_score = nil
      if current_high_score && score > current_high_score
        high_score = score
      elsif !current_high_score
        high_score = score
      end
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
            game.score = score
            game.save
          end
        else
          user.credits = user.credits + earned_credits
          if user.save(validate: false)
            game.credits_earned = 0 if game.credits_earned.nil?
            game.credits_earned = game.credits_earned + earned_credits
            game.score = score
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
      :score => high_score,
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

  def set_heli
    game = UserGameSession.new
    game.token = SecureRandom.urlsafe_base64
    game.user_id = current_user.id
    game.game_id = Game.where(name: "Helicopter").first.id
    game.credits_earned = 0
    game.active = true
    game.arrival_id = session[:arrival_id]
    game.save
    if !session[:game_token].nil?
     old_game = UserGameSession.where(token:session[:game_token]).first
     #close previous game game
     if old_game
      old_game.active = false
      old_game.save
     end
    end 
    duration = (Time.now.to_i - game.created_at.to_i).to_i
    if duration > 999.seconds
      duration = 999.seconds
    end
    session[:game_token] = game.token   
    game_json = {
      :status => "success",
      :token => game.token, 
      :duration => duration
    }        
  end


  #for when clicking 'new game' within a game
  def new_game_session

    old_game = UserGameSession.where(token:session[:game_token]).first
    set_game_token({game_name:old_game.game.name})
    game_json = {
      :status => "success",
      :token =>  session[:game_token]
    } 

    render json: game_json
  end
  #for when clicking 'new game' within construct 2 games
  def reset_game

    old_game = UserGameSession.where(token:session[:game_token]).last
    set_game_token({game_name:old_game.game.name})
    if UserGameSession.where(user_id:current_user.id,game_id:old_game.game.id).where.not(score: nil).order("score desc").present?
      high_score = UserGameSession.where(user_id:current_user.id,game_id:old_game.game.id).where.not(score: nil).order("score desc").first.score 
    else
      high_score = 0
    end
    if old_game.game.slug == 'flappy-pilot'
        high_score = high_score.to_s.rjust(3, '0')
    end
    game_json = {
      :c2dictionary => true,
      :data => { 
       :earned => 0,
       :total_credits => old_game.user.credits,
       :token => session[:game_token],
       :hscore => high_score       
      } 
    }
    render json: game_json
  end

  def set_game_token(args={})
    score = args[:score] ||= 0
    game_name = args[:game_name] ||= "Memory Game"
    if current_user
      old_games = UserGameSession.where(user_id:current_user.id,active:true)
      old_games.each do | o |
        o.active = false
        o.save
      end
      game = UserGameSession.new
      game.token = SecureRandom.urlsafe_base64
      game.user_id = current_user.id
      game.game_id = Game.where(name: game_name).first.id
      game.credits_earned = 0
      game.active = true
      game.score = score
      game.arrival_id = session[:arrival_id]
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
    end       
  end

  private
  
  def get_credits_to_apply(game_name,score,credits_applied)
    case game_name
      when "Sorcerer Game"
        credits = (score/1000.to_f).ceil - 1 #subtract 1 otherwise itll give a credit once anything is scored
      when "2048"
        credits = (score/1000.to_f).ceil - 1 
      when "Traffic"
        credits = (score/10.to_f).ceil - 1   
      when "Flappy Pilot"
        credits = (score/10.to_f).ceil - 1                
      when "Black Hole"
        #credits = score * 5   
        credits_to_apply = 3
    end

    credits_to_apply = credits - credits_applied unless !credits_to_apply.nil?
    credits_to_apply 
  end

    def create_new_game_session(score,game_id)
     # old_game = UserGameSession.where(user_id:current_user).last
      set_game_token({game_name:Game.where(id:game_id).first.name,score:score})
    end 
    # Use callbacks to share common setup or constraints between actions.
    def set_game
      @game = Game.find(params[:id])
      if @game.name == "Helicopter"
        set_heli
      end
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
        game.arrival_id = session[:arrival_id]
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

    def get_traffic_json
    end     
end
