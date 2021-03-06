module AdLogic
  def get_ad
    determine_ad_number
  end

  def default_ad_number
    rand(2..5)
  end

  def determine_ad_number
    survey = Survey.where(slug:'checking').last

    #make sure they took survey otherwise go to by demographic ad
    if current_user && survey && current_user.user_surveys.where(survey_id:survey.id).present?
      return by_checking_survey
    elsif current_user
      return by_demo
    else 
      return default_ad_number
    end

  end


  #TODO: Clean this shit up to make more flexible rushing through for demos
  def by_checking_survey
   have_account_question = Question.where(slug:'has-checking').first
   yes = Answer.where(text:'yes').first
   no = Answer.where(text:'no').first

   has_checking_account = have_account_question.user_survey_answers.where(user_id:current_user.id,answer_id:yes.id).present?

    if has_checking_account
      if (13..29).include?(current_user.age)
        AdUnit.where(slug:'kia-soul-fall-1').first.ad_number
      elsif (30..999).include?(current_user.age) 

        features_question = Question.where(slug:'checking-features').first
        satisfaction_question = Question.where(slug:'checking-satisfaction').first

        fees = Answer.where(text:"No fees").first.id
        fraud_alert = Answer.where(text:"Fraud alerts").first.id
        deposit = Answer.where(text:"Electronic deposit").first.id

        features_answer = features_question.user_survey_answers.where(user_id:current_user.id).first
      
        negative_answers = ['Not at all satisfied','Unsatisfied','Neutral','Satisfied']
        negative_answer_ids = Answer.where(text:negative_answers).pluck(:id)

        is_unhappy = satisfaction_question.user_survey_answers.where(user_id:current_user.id,answer_id:negative_answer_ids).present?

        if is_unhappy && features_answer
          case features_answer.answer_id
            when fees
               AdUnit.where(slug:'capital-one-fall-1').first.ad_number
            when fraud_alert
               AdUnit.where(slug:'pnc-fall-1').first.ad_number
            when deposit 
               AdUnit.where(slug:'regions-bank-fall-1').first.ad_number
          end
        else
          AdUnit.where(slug:'bmw-fall-1').first.ad_number
        end
      else
        default_ad_number
      end
    else
      if (13..17).include?(current_user.age)
        AdUnit.where(slug:'chase-fall-1').first.ad_number
      elsif (30..999).include?(current_user.age) 
        AdUnit.where(slug:'bmw-fall-1').first.ad_number
      else
        default_ad_number
      end
    end
  end
  
  def by_demo
    if (13..29).include?(current_user.age)
      AdUnit.where(slug:'kia-soul-fall-1').first.ad_number
    elsif (30..999).include?(current_user.age) 
      AdUnit.where(slug:'bmw-fall-1').first.ad_number
    else
      default_ad_number
    end    
  end

    
end
