require 'rake'

task :add_oscars_survey => :environment do | t, args |
  b = Survey.create({name: "The Oscars", slug:"oscars-survey",credits:25})
end

task :add_travel_survey => :environment do | t, args |
  b = Survey.create({name: "Travel", slug:"travel-survey",credits:25})
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
