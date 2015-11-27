class SurveysController < ApplicationController
  include ApplicationHelper

  before_action :set_survey, only: [:show, :edit, :update, :destroy]
  before_action :admin_user,     only: [:destroy, :new, :edit]
  before_filter :check_signed_in


  layout :determine_layout

  # GET /surveys
  # GET /surveys.json
  def index
    @show_back_button = true
    @surveys = Survey.all
    if is_mobile?
      render "surveys/index_mobile"
    end
  end

  def check_signed_in
    redirect_to root_path if !signed_in?
  end

  # GET /surveys/1
  # GET /surveys/1.json
  def show
    @show_back_button = true
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

    if is_mobile?
      render "surveys/show_mobile"
    end
  end

  def user_survey_save
    @user_survey = UserSurvey.where(id:params[:user_survey][:id]).first
    if @user_survey
      current_user.add_credits({credits:@user_survey.survey.credits})
      @user_survey.complete = true
      @user_survey.save
      flash[:success] = "Thank you for completing the survey!"
    else
      flash[:error] = "Something went wrong saving the survey. Please try again later."
    end

    redirect_to surveys_path
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
      params[:survey].permit(:name, :credits)
    end

    def admin_user
      redirect_to(root_url) unless current_user && current_user.admin?
    end
end
