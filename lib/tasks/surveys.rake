require 'rake'

task :add_oscars_survey => :environment do | t, args |
  b = Survey.create({name: "The Oscars", slug:"oscars-survey",credits:25})
end

task :add_travel_survey => :environment do | t, args |
  b = Survey.create({name: "Travel", slug:"travel-survey",credits:25})
end

#PLAN ON HAVING A CREATOR MUCH MORE SIMPLE THAN THIS AHHGH THIS IS A MESS
task :add_checking_account_survey => :environment do | t, args | 
  b = Survey.create({name: "Checking Survey", slug:"checking",credits:25, survey_type:"conditional"})
  
  qc =  Question.create({text:"Do you have a checking account?",question_type:"condition"})

  sqc = SurveyQuestion.create({survey_id: b.id, question_id: qc.id, display_order: 1})
    ac1 = Answer.where({text:"yes"}).first
  sqca1 =  SurveyQuestionAnswer.create({survey_question_id: sqc.id,answer_id:ac1.id})
    ac2 = Answer.where({text:"no"}).first
  sqca2 =  SurveyQuestionAnswer.create({survey_question_id: sqc.id,answer_id:ac2.id})

  #IF NO QUESTIONS
  q2a =  Question.create({text:"How soon would you consider opening a checking account?",question_type:"multiple"})
    sq1 = SurveyQuestion.create({survey_id: b.id, question_id: q2a.id, display_order: 2, condition_id:ac2.id})
    a1 = Answer.create({text:"Today"})
     sqa1 =  SurveyQuestionAnswer.create({survey_question_id: sq1.id,answer_id:a1.id})

    a2 = Answer.create({text:"This month"})
     sqa2 =  SurveyQuestionAnswer.create({survey_question_id: sq1.id,answer_id:a2.id})
     
    a3 = Answer.create({text:"This year"})
     sqa3 =  SurveyQuestionAnswer.create({survey_question_id: sq1.id,answer_id:a3.id})

    a4 = Answer.create({text:"2-5 years"})
     sqa4 =  SurveyQuestionAnswer.create({survey_question_id: sq1.id,answer_id:a4.id})

    a5 = Answer.create({text:"Never"})
     sqa5 =  SurveyQuestionAnswer.create({survey_question_id: sq1.id,answer_id:a5.id})



  q3a =  Question.create({text:"What would be the most important factor for you when considering opening a checking account?",question_type:"multiple"})

    sq3a = SurveyQuestion.create({survey_id: b.id, question_id: q3a.id, display_order:3,condition_id:ac2.id})
    a1 = Answer.create({text:"Convenience"})
     sqa1 =  SurveyQuestionAnswer.create({survey_question_id: sq3a.id,answer_id:a1.id})

    a2 = Answer.create({text:"No Fees"})
     sqa2 =  SurveyQuestionAnswer.create({survey_question_id: sq3a.id,answer_id:a2.id})
     
    a3 = Answer.create({text:"Distance to branch locations"})
     sqa3 =  SurveyQuestionAnswer.create({survey_question_id: sq3a.id,answer_id:a3.id})
  ####END IF NO ##

  ###IF YES QUESTIONS
  #IF NO QUESTIONS
  q2a =  Question.create({text:"How satisfied are you with your current checking account provider?",question_type:"multiple"})
    sq1 = SurveyQuestion.create({survey_id: b.id, question_id: q2a.id, display_order: 2,condition_id:ac1.id})
    a1 = Answer.create({text:"Not at all satisfied"})
     sqa1 =  SurveyQuestionAnswer.create({survey_question_id: sq1.id,answer_id:a1.id})

    a2 = Answer.create({text:"Unsatisfied"})
     sqa2 =  SurveyQuestionAnswer.create({survey_question_id: sq1.id,answer_id:a2.id})
     
    a3 = Answer.create({text:"Neutral"})
     sqa3 =  SurveyQuestionAnswer.create({survey_question_id: sq1.id,answer_id:a3.id})

    a4 = Answer.create({text:"Satisfied"})
     sqa4 =  SurveyQuestionAnswer.create({survey_question_id: sq1.id,answer_id:a4.id})

    a5 = Answer.create({text:"Extremely satisfied"})
     sqa5 =  SurveyQuestionAnswer.create({survey_question_id: sq1.id,answer_id:a5.id})



  q3a =  Question.create({text:"What is the most important checking account feature for you?",question_type:"multiple"})

    sq3a = SurveyQuestion.create({survey_id: b.id, question_id: q3a.id, display_order:3,condition_id:ac1.id})
    a1 = Answer.create({text:"No fees"})
     sqa1 =  SurveyQuestionAnswer.create({survey_question_id: sq3a.id,answer_id:a1.id})

    a2 = Answer.create({text:"Electronic deposit"})
     sqa2 =  SurveyQuestionAnswer.create({survey_question_id: sq3a.id,answer_id:a2.id})
     
    a3 = Answer.create({text:"fraud alerts"})
     sqa3 =  SurveyQuestionAnswer.create({survey_question_id: sq3a.id,answer_id:a3.id})

end

#PLAN ON HAVING A CREATOR MUCH MORE SIMPLE THAN THIS AHHGH THIS IS A MESS
task :add_bellhop_survey => :environment do | t, args | 
  b = Survey.create({name: "Bellhops Survey", slug:"bellhops",credits:25, survey_type:"video"})
  
  qv =  Question.create({text:"KoGTWwV0YE8",question_type:"video"})

  sqv = SurveyQuestion.create({survey_id: b.id, question_id: qv.id, display_order: 3})
  a = Answer.create({text:"watched video"})
  
  sqa =  SurveyQuestionAnswer.create({survey_question_id: sqv.id,answer_id:a.id})
  q1 =  Question.create({text:"Which feature would you rather have in a college job?",question_type:"multiple"})

  sq1 = SurveyQuestion.create({survey_id: b.id, question_id: q1.id, display_order: 2})
  a1 = Answer.create({text:"$13-$15 per hour plus tips"})
   sqa1 =  SurveyQuestionAnswer.create({survey_question_id: sq1.id,answer_id:a1.id})

  a2 = Answer.create({text:"Freedom to set your own schedule"})
   sqa2 =  SurveyQuestionAnswer.create({survey_question_id: sq1.id,answer_id:a2.id})
   
  a3 = Answer.create({text:"Great customer reviews to build your resume"})
   sqa3 =  SurveyQuestionAnswer.create({survey_question_id: sq1.id,answer_id:a3.id})

  q2 =  Question.create({text:"Do you currently attend a college or university?",question_type:"yesno"})

  sq2 = SurveyQuestion.create({survey_id: b.id, question_id: q2.id, display_order:1})

  a21 = Answer.create({text:"yes"})
    sqa1 =  SurveyQuestionAnswer.create({survey_question_id: sq2.id,answer_id:a21.id})
  a22 = Answer.create({text:"no"})
    sqa1 =  SurveyQuestionAnswer.create({survey_question_id: sq2.id,answer_id:a22.id})

end
