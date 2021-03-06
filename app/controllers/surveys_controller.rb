class SurveysController < ApplicationController
  include ApplicationHelper

  before_action :set_survey, only: [:show, :edit, :update, :destroy]
  before_action :admin_user,     only: [:destroy, :new, :edit]
  before_filter :check_signed_in


  layout :determine_layout

  # GET /surveys
  # GET /surveys.json
  def index
    cookies[:survey] = 1

    @current_page = "surveys"
    @surveys = Survey.order(created_at: "desc").all
    if is_mobile?
      render "index_mobile"
    end
  end

  def check_signed_in
    redirect_to root_path if !signed_in?
    redirect_to confirmed_path if signed_in? && current_user && !current_user.profile_complete?
  end

  def dunkin_index
    @surveys = Survey.where(name: "Coffee Survey")

    if is_mobile?
      render "index_mobile"
    else
      render "index"
    end
  end

  # GET /surveys/1
  # GET /surveys/1.json
  def show
    @show_back_button = true

    #TODO: add this to database to have dynamic conditions in questions
    if @survey.survey_type == "conditional"
      @yes_id = Answer.where(text:"yes").first.id
      @no_id = Answer.where(text:"no").first.id
    end
    if UserSurvey.where(user_id:current_user.id,survey_id:@survey.id).present?
      @user_survey =  UserSurvey.where(user_id:current_user.id,survey_id:@survey.id).first
    else
      @user_survey = UserSurvey.new
      @user_survey.survey_id = @survey.id
      @user_survey.user_id = current_user.id
      @user_survey.complete = false
      @user_survey.arrival_id = session[:arrival_id]
      @user_survey.save
    end
  end

  def user_survey_save
    @user_survey = UserSurvey.where(id:params[:user_survey][:id]).first
    if @user_survey && @user_survey.complete != true
      @user_survey.credits = @user_survey.survey.credits
      @user_survey.complete = true
      if @user_survey.save
        current_user.add_credits({credits:@user_survey.survey.credits})
        if params[:question] && !params[:question].blank?
          params[:question].each do | q  |
             user_survey_answer = UserSurveyAnswer.create({user_id: current_user.id,survey_question_id: q[0], user_survey_id: @user_survey.id,survey_question_answer_id: q[1], question_id: SurveyQuestion.find(q[0]).question.id, answer_id: SurveyQuestionAnswer.find(q[1]).answer.id})
          end
        end
      end
      flash[:success] = "Thank you for completing the survey!"
    elsif @user_survey.complete == true
      flash[:notice] = "This survey has been completed."
    else
      flash[:error] = "Something went wrong saving the survey. Please try again later."
    end

    if Survey.find(@user_survey.survey_id).slug == "bellhops"
      redirect_to bellhops_affiliate_path
    elsif is_dunkin_user?
      redirect_to dunkin_path
    else
      redirect_to surveys_path
    end
  end

  # GET /surveys/new
  def new
    @survey = Survey.new
  end

  # GET /surveys/1/edit
  def edit
  end

  # POST /surveys
  # POST /surveys.json
  def create
    @survey = Survey.new(survey_params)

    respond_to do |format|
      if @survey.save
        format.html { redirect_to @survey, notice: 'Survey was successfully created.' }
        format.json { render action: 'show', status: :created, location: @survey }
      else
        format.html { render action: 'new' }
        format.json { render json: @survey.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /surveys/1
  # PATCH/PUT /surveys/1.json
  def update
    respond_to do |format|
      if @survey.update(survey_params)
        format.html { redirect_to @survey, notice: 'Survey was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @survey.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /surveys/1
  # DELETE /surveys/1.json
  def destroy
    @survey.destroy
    respond_to do |format|
      format.html { redirect_to surveys_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_survey
      @survey = Survey.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def survey_params
      params[:survey].permit(:name, :credits, survey_questions_attributes: [:id,
                                                                            :survey_id,
                                                                            :question_id,
                                                                            :_destroy,
                                                                            question_attributes: [:text,
                                                                                                  :question_type,
                                                                                                  :_destroy],
                                                                            survey_question_answers_attributes: [:id,
                                                                                                                :survey_question_id,
                                                                                                                :answer_id,
                                                                                                                :_destroy,
                                                                                                                answer_attributes: [:id,
                                                                                                                                    :text,
                                                                                                                                    :_destroy]]])
    end

    def admin_user
      redirect_to(root_url) unless current_user && current_user.admin?
    end
end
