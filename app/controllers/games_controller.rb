class GamesController < ApplicationController
    before_action :set_game, only: [:show, :purchase_confirm, :edit, :update, :destroy]

    before_action :check_purchase, only: [:show]
    before_filter :set_dunkin, only: [:dunkin]
    before_filter :check_signed_in,:set_notifications, except:[:check_branded]
    skip_before_filter  :verify_authenticity_token, only:[:score_update,:reset_game,:get_random_challenge_user, :check_branded]

    include ApplicationHelper
    include GamesHelper
    require "#{Rails.root}/lib/ad_logic.rb"

    include AdLogic

    layout :determine_layout

    def check_purchase
        redirect_to root_path if (@game.device_type == 5 && current_user && !current_user.has_purchased_game(@game.id)) || current_user.nil?
        true
    end

    def check_branded
        ad_id = 0
        ad_number = 0
        if session[:ad_id]
            ad_id = session[:ad_id]
            if ad_id.to_i == Advertiser.where(slug:'dunkin-donuts').first.id && params[:slug] == 'flappy-pilot'
                ad_number = 9
            end
        end
        res = {
            :c2dictionary => true,
            :data => {
             :branded => params[:slug] == 'flappy-pilot' ? ad_number : 0
            }
        }
        render json: res
    end

    def fetch_assets
        slug = params[:slug]
        #check for current campaigns
    end

    # GET /games
    # GET /games.json
    def index
        #TODO: Fix this hack
        if request && request.referer && request.referer.include?('?a=')
            redirect_to dunkin_path
        end
        @current_page = "games"

        if is_mobile?
            @games = Game.mobile.order("sort_order asc")
        else
            @games = Game.desktop.order("sort_order asc")
        end

        @is_mobile = is_mobile?

        render "games/index_mobile" if is_mobile?
    end

    def dunkin
        @current_page = "games"
        @advertiser_id = Advertiser.where(slug:"dunkin-donuts").first.id
        @dunkin_user = is_dunkin_user?

        game_ids = BrandedGameProperty.where(advertiser_id: @advertiser_id).map{|g| g.game_id }
        @games = Game.where(id:game_ids).order("sort_order asc")

        @is_mobile = is_mobile?
        if is_mobile?
            render "games/index_mobile"
        else
            render "games/index"
        end
    end

    def purchase_confirm
        if @game.device_type == 5 && current_user && !current_user.has_purchased_game(@game.id)
            @purchase = Purchase.new
        else
            redirect_to root_path, :notice => "You have already unlocked #{@game.name}!"
        end
    end

    def check_signed_in
        if params[:vid] && User.find_by_verify_token(params[:vid])
            verify_link = true
        end
        redirect_to root_path if !signed_in? && !verify_link
        redirect_to confirmed_path if signed_in? && current_user && !current_user.profile_complete?

    end

    #sets notifications for surveys not taken
    def set_notifications
        if !cookies[:survey]
            if current_user && !current_user.surveys.include?(Survey.last)
                cookies[:survey] = { value: 0, expires: 1.week.from_now }
            elsif current_user
                cookies[:survey] = {value: 1, expires: 1.week.from_now}
            end
        else
            #fix expiring permanent show once a week
            cookies[:survey] = { value: cookies[:survey], expires: 1.week.from_now }
        end
    end

    def get_random_challenge_user
        @random_user = User.order("RANDOM()").first
        respond_to do |format|
            format.js
        end
    end

    def new_game
        @game = Game.where(slug:params[:slug]).first
        create_game_session
        current_high_score = UserGameSession.where(user_id:current_user.id,game_id:@game.id).where.not(score: nil).order("score desc").first.score if UserGameSession.where(user_id:current_user.id,game_id:@game.id).where.not(score: nil).order("score desc").present?

        game_json = {
            :c2dictionary => true,
            :data => {
             :earned => 0,
             :total_credits => current_user.credits,
             :token => session[:game_token],
             :challenge => false,
             :hscore => current_high_score
            }
        }

    end

    def close_game_new
        game_session = UserGameSession.where(token:params[:game_token]).first
        game_session.active = false
        game_session.save
            game_json = {
                :c2dictionary => true,
                :data => {
                 :earned => game_session.credits_earned,
                 :total_credits => current_user.credits,
                 :token => game_session.token,
                 :status => status,
                 :hscore => current_high_score
                }
            }
        game_json
    end

    # GET /games/1
    # GET /games/1.json
    def show
        #TODO: make this legit

        if params[:a] && Advertiser.where(id:params[:a]).present?
            session[:ad_id] = params[:a]
        else
            session[:branded_ad] = nil
            session[:ad_id] = nil
        end

        @show_back_button = true

        case @game.name
            when "Memory Game"
                @top_scores = UserGameSession.where(game_id:@game.id).where.not(score:nil).order("score asc").limit(10)
            when "Helicopter"
                @top_scores = UserGameSession.where(game_id:@game.id).where.not(score:nil).order("score desc").limit(10)
            when "Sorcerer Game","2048","Black Hole"
                set_game_token({game_name:@game.name})
        end

        @current_high_score = UserGameSession.where(user_id:current_user.id,game_id:@game.id).where.not(score: nil).order("score desc").first.score if UserGameSession.where(user_id:current_user.id,game_id:@game.id).where.not(score: nil).order("score desc").present?
        #@current_high_score = Time.at(@current_high_score).utc.strftime("%M:%S") if @current_high_score && @game.name == "Memory Game"


        render "games/show_mobile" if is_mobile?
    end


    def close_game
        status = 'error'
        if params[:token] && !params[:token].empty?
            status = "success"

            game_session = UserGameSession.where(token: params[:token]).first
            score = game_session.score
            game_session.active = false
            game_session.save
            #current_high_score = UserGameSession.where(user_id:current_user.id,game_id:game_session.game.id).where.not(score: nil).order("score desc").first.score

            current_high_score = current_user.get_highscore({timeframe:'at',slug: game_session.game.slug,version:game_session.version})

            case game_session.game.slug
                when '2048','black-hole','sorcerer-game'
                    game_json = {
                         :earned => game_session.credits_earned,
                         :total_credits => current_user.credits,
                         :token => game_session.token,
                         :status => status,
                         :hscore => current_high_score
                        }
                when 'flappy-pilot','traffic','fall-down','tap-color'
                    if game_session.game.slug == 'flappy-pilot'
                        current_high_score = current_high_score.to_s.rjust(3, '0')
                    end
                    game_json = {
                        :c2dictionary => true,
                        :data => {
                         :earned => game_session.credits_earned,
                         :total_credits => current_user.credits,
                         :token => game_session.token,
                         :status => status,
                         :hscore => current_high_score
                        }
                    }
            end
        end
    end


    # Intermediate Page
    def twentyfortyeight_home
        @show_back_button = true

        @game = Game.where(name: "2048").first
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
            if game_session && game_session.active && user.enabled != false
                game_session.last_score_update = Time.now
                credits_to_apply = get_credits_to_apply(game_session.game.slug,score,game_session.credits_applied,game_session.version)
                if user && credits_to_apply > 0
                    user.add_credits({credits:credits_to_apply})
                    game_session.credits_applied += credits_to_apply
                elsif !user
                    status = "error"
                else
                    status = "nothingearned"
                end
                if false && session[:challenge_id]
                 other_game_session = UserGameSession.where(challenge_id:session[:challenge_id],user_id:current_user.id).where.not(score:[nil,0]).where.not(id:game_session.id)
                 #if already finished challenge game, get rid of session variable
                 if other_game_session.present?
                     session[:challenge_id] = nil
                 else
                    challenge = Challenge.where(id:session[:challenge_id]).first
                    game_session.challenge_id = challenge.id
                 end
                end
                if score > 0
                    game_session.score = score
                else
                    game_session.score = 0
                end
                game_session.credits_earned += credits_to_apply
                if !params[:finish].blank?
                    game_session.active = false
                    session[:game_token] = nil
                end
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
            elsif user.enabled != false
                status = "user not active"
            elsif game_session && !game_session.active
                status = "closed"
            elsif !game_session
                game_id = request.referer.split('/').last.to_i
                create_new_game_session(params[:score],game_id)
                status = "skip"
            else
                status = "skip"
            end
            if game_session

                current_high_score = current_user.get_highscore({timeframe:'at',slug: game_session.game.slug,version:game_session.version})

                #need = since when high score it will actually be current, maybe add background job to run calcs?
                if score >= current_high_score
                    $redis.del("at_#{game_session.game.slug}_#{game_session.version}")
                    $redis.del("w_#{game_session.game.slug}_#{game_session.version}")
                elsif $redis.get("w_#{game_session.game.slug}_v#{game_session.version}_user_#{user.id}") && JSON.parse($redis.get("w_#{game_session.game.slug}_v#{game_session.version}_user_#{user.id}"))["score"]
                    $redis.del("w_#{game_session.game.slug}_#{game_session.version}")
                    $redis.del("w_#{game_session.game.slug}_v#{game_session.version}_user_#{user.id}")
                elsif $redis.get("w_#{game_session.game.slug}_v#{game_session.version}_user_#{user.id}").blank?
                    $redis.del("w_#{game_session.game.slug}_#{game_session.version}")
                end
            end
        elsif params[:score] && !params[:score].empty?
            if challenge
                game_id = challenge.game_id
            elsif request && request.referer
                game_id = request.referer.split('/').last.to_i
            end

            create_new_game_session(params[:score],game_id)
            game_session = UserGameSession.where(token: session[:game_token]).first
        end

        #shouldnt happen just a safety check
        if game_session
            case game_session.game.slug
                when '2048','black-hole','sorcerer-game'
                    game_json = {
                         :earned => game_session.credits_earned,
                         :total_credits => user.credits,
                         :token => game_session.token,
                         :status => status,
                         :hscore => current_high_score
                        }
                when 'flappy-pilot','traffic','fall-down','tap-color','gold-runner'
                    if game_session.game.slug == 'flappy-pilot'
                        current_high_score = current_high_score.to_s.rjust(3, '0')
                    end
                    game_json = {
                        :c2dictionary => true,
                        :data => {
                         :earned => game_session.credits_earned,
                         :total_credits => user.credits,
                         :token => game_session.token,
                         :status => status,
                         :hscore => current_high_score
                        }
                    }
            end
        else
             game_json = {
                     :earned => "0",
                     :total_credits => user.credits,
                     :token => session[:game_token],
                     :status => status,
                     :hscore => current_high_score
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

    def get_high_scores
        if !params[:slug].blank?
         game = Game.where(slug:params[:slug]).first
         game_json = {
            :c2dictionary => true,
            :data => {
             :v1score => get_current_highscore_for_version({game_id:game.id,version_id:1}),
             :v2score => get_current_highscore_for_version({game_id:game.id,version_id:2}),
             :v3score => get_current_highscore_for_version({game_id:game.id,version_id:3})
            }
         }
        else
         game_json = {
            :c2dictionary => true,
            :data => {
             :v1score => 0,
             :v2score => 0,
             :v3score => 0
            }
         }
        end
        render json: game_json
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
        if session[:challenge_id]
            #TODO: Finish challenges
        end
        version = nil
        newgame = false
        if params[:newgame] && params[:newgame] == "true" && params[:slug]
            newgame = true
            game = Game.where(slug:params[:slug]).first
            game_id = game.id
            if !params[:v].blank?
                version = params[:v].to_i
            end
        end
        if !newgame && session[:game_token]
            old_game = UserGameSession.where(token:session[:game_token]).last
        end

        if !newgame && !old_game
            game_id = request.referer.split('/').last.to_i
            old_game_name = Game.where(id:game_id).last.name
        elsif old_game
            old_game_name = old_game.game.name
            game_id = old_game.id
            if old_game_name == '2048'
                # if old_game.created_at >= Time.now-2.minutes
                #     redirect_to root_path, notice: 'Rate limit on games hit. Please play check back later.'
                # end
            end
        end

        if newgame
            set_game_token({game_name:game.name,version:version})
        else
            set_game_token({game_name:old_game_name})
        end
        # TODO: this is all gettng messy need to clean this up and standardize
        if game && game.slug == "tap-color"
            version = 1
            if params[:v] && !params[:v].blank?
                version = params[:v].to_i
            end
            high_score = get_current_highscore_for_version({game_id:game_id,version_id:version})
        else
            high_score = get_current_highscore({game_id:game_id})
        end

        if old_game
            if !old_game.challenge_id.nil?
                challenge = Challenge.where(id:old_game.challenge_id).first
                # if current_user.id == challenge.user_id
                #   challenge.user_score = old_game.score
                #   challenge.save
                # elsif current_user.id == challenge.challenged_user_id
                #   challenge.challenged_score = old_game.score
                #   challenge.save
                # end
                if challenge
                    save = false
                     challenged_user_session = UserGameSession.where.not(score:nil).where.not(score:0).where(challenge_id:challenge.id,user_id:challenge.challenged_user_id).first
                     challenger_user_session = UserGameSession.where.not(score:nil).where.not(score:0).where(active:false, challenge_id:challenge.id,user_id:challenge.user_id).first
                    p "FOUND CHALLENGED USER SESSION #{challenged_user_session.id}"
                    if challenged_user_session && challenged_user_session.user_id == current_user.id
                        challenge.challenged_score = old_game.score
                        save = true
                    end

                    if challenger_user_session && challenger_user_session.user_id == current_user.id
                        challenge.user_score = old_game.score
                        save = true
                    end

                    if challenged_user_session.present? && challenger_user_session.present?
                        p challenged_user_session
                        p challenger_user_session
                        challenge.winner_id = ((challenged_user_session.score > challenger_user_session.score.to_i) ? challenged_user_session.user_id : challenger_user_session.user_id)
                     # challenge.user_score = challenger_user_session.score
                     # challenge.challenged_score = challenged_user_session.score
                        save = true
                        #TODO: email people the results?
                    end
                    if save
                        challenge.save
                        session[:challenge_id] = nil
                    end
                end
            end

            if old_game.game.slug == 'flappy-pilot'
                    high_score = high_score.to_s.rjust(3, '0') #for the way this needs it

            end
        end

        if newgame && game.slug == "fall-down"
            if session[:branded_ad]
                ad_number = session[:branded_ad]
            else
                ad_number = get_ad
            end

            if ad_number && ad_number != 1
                AdDisplay.create({user_game_session_id:UserGameSession.where(token:session[:game_token]).first.id,user_id:current_user.id, game_id:game.id,ad_number:ad_number})
            end

            game_json = {
                :c2dictionary => true,
                :data => {
                 :earned => 0,
                 :total_credits => current_user.credits,
                 :token => session[:game_token],
                 :hscore => high_score,
                 :ad_number => ad_number
                }
            }
        else
            game_json = {
                :c2dictionary => true,
                :data => {
                 :earned => 0,
                 :total_credits => current_user.credits,
                 :token => session[:game_token],
                 :hscore => high_score
                }
            }
        end

        render json: game_json
    end

    # def leaderboard
    #     @current_page = "leaderboard"
    #     @game = Game.where(slug:params[:game_slug]).first
    # end

    def leaderboard
        @current_page = "leaderboard"
        @game = Game.where(slug:params[:game_slug]).first

        # if is_mobile?
        #     render "games/leaderboard"
        # else
        #     render "games/leaderboard_old"
        # end

        render "games/leaderboard"
    end

    def games_leaderboard
        @current_page = "leaderboard"
        if is_mobile?
            @games = Game.mobile.order("sort_order asc")
            render "games/games_leaderboard_new"
        else
            @games = Game.desktop.order("sort_order asc")
        end
    end

    #updated for construct2 games
    def create_game_session
            game_session = UserGameSession.new
            game_session.token = SecureRandom.urlsafe_base64
            game_session.user_id = current_user.id
            game_session.game_id = @game.id
            game_session.credits_earned = 0
            game_session.active = true
            game_session.score = score
            game_session.arrival_id = session[:arrival_id]
            game_session.save
            if !session[:game_token].nil?
             old_game = UserGameSession.where(token:session[:game_token]).first

             #close previous game game just in case
             if old_game
                old_game.active = false
                old_game.save
             end

            end
            session[:game_token] = game.token
    end

    #TODO: CLEAN THIS UP! SHITS GETTN CRAZY!
    def set_game_token(args={})

        score = args[:score] ||= 0
        game_name = args[:game_name] ||= "Memory Game"
        version = args[:version] ||= nil
        if current_user
            old_games = UserGameSession.where(user_id:current_user.id,active:true)
            # if old_games && old_games.last.created_at >= (Time.now-1.minutes-30.seconds)
            #     redirect_to root_path, notice: 'Rate limit on games hit. Please play check back later.'
            # end
            old_games.each do | o |
                o.active = false
                o.save
            end

            game = UserGameSession.new
            game.token = SecureRandom.urlsafe_base64
            game.user_id = current_user.id
            if version
                game.version = version
            end
            game.game_id = Game.where(name: game_name).first.id
            game.credits_earned = 0
            game.active = true
            if session[:challenge_id] && UserGameSession.where(user_id:current_user.id,challenge_id:session[:challenge_id])
                game.challenge_id = session[:challenge_id]
            end
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

    def challenge
        @game = Game.where(slug:params[:game_slug]).first
        @challenge = Challenge.new
    end

    def challenge_create
        challenge = Challenge.new(challenge_params)
        if challenge.save
            session[:challenge_id] = challenge.id
            UserNotifier.send_challenge_email({user_id:challenge.challenged_user_id,game_name:challenge.game.name, challenger_id:current_user.id}).deliver
            redirect_to game_path(challenge.game_id)
        else
            redirect_to game_challenge_path(game_slug:Game.find(challenge.game_id).slug)
        end
    end

    def pre_challenge
        @challenge = Challenge.new
    end

    private

    def get_credits_to_apply(slug,score,credits_applied,version=nil)

        case slug
            when "sorcerer-game"
                credits = (score/5000.to_f).ceil - 1 #subtract 1 otherwise itll give a credit once anything is scored
            when "2048"
                case score
                    when 5000..9999
                        credits = 1
                    when 10000..13999
                        credits = 2
                    when 14000..99999999999999
                        credits = (score/3000.to_f).ceil - 2
                    else
                        credits = 0
                end
            when "traffic"
                credits = (score/14.to_f).ceil - 1
            when "flappy-pilot"
                credits = (score/16.to_f).ceil - 1
            when "black-hole"
                #credits = score * 5
                credits_to_apply = 0
            when "fall-down"
                credits = (score/25.to_f).ceil - 1
            when "tap-color"
                case version
                    when 1
                        credits = (score/15.to_f).ceil - 1
                    when 2
                        credits = (score/15.to_f).ceil - 1
                    when 3
                        credits = (score/15.to_f).ceil - 1
                    else
                        credits = (score/15.to_f).ceil - 1
                end
            when 'gold-runner'
                case score
                    when 5..14
                        credits = 1
                    when 11..18
                        credits = 2
                    when 19..27
                        credits = 3
                    when 28..37
                        credits = 4
                    when 37..99999
                        credits = (score/10.to_f).ceil + 1
                    else
                        credits = 0
                end
                #credits = (score/3.to_f).ceil - 1
                credits
        end
        if credits < 0
            credits = 0
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
        if params[:c] && !params[:c].blank? && params[:id].blank?
             challenge = Challenge.where(id:Base64.urlsafe_decode64(params[:c]).to_i).first
             @game = challenge.game
             if challenge && current_user.challenges.include?(challenge)
                if challenge.user_id == current_user.id && (challenge.user_score.nil? || challenge.user_score == 0)
                    session[:challenge_id] = challenge.id
                elsif challenge.challenged_user_id == current_user.id && (challenge.challenged_score.nil? || challenge.user_score == 0)
                    session[:challenge_id] = challenge.id
                end
             end
        elsif params[:slug] && !params[:slug].blank?
            @game = Game.where(slug:params[:slug]).first
        else
            @game = Game.find(params[:id])
        end

        if @game.name == "Helicopter"
            set_heli
        end
    end

    #auto sign in dunkin demo user for this url
    def set_dunkin
        session[:branded_ad] = 9
        if !signed_in?
            pass = SecureRandom.urlsafe_base64

            user = User.where(:name => 'DunkinDemo').first_or_initialize({name:"DunkinDemo", firstname:"Dunkin",lastname:"Demo",dob:Time.now-50.years,gender: 1,password:pass, password_confirmation:pass,credits:0,email:"tyler+demodd1@getluckee.com",email_verified: true, arrival_id: session[:arrival_id]})
            sign_in user
        end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def game_params
        params.require(:game).permit(:name)
    end

    def challenge_params
        params.require(:challenge).permit(:user_id,:game_id,:challenged_user_id)
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
