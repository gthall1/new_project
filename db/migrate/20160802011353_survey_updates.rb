class SurveyUpdates < ActiveRecord::Migration
  def change
    Survey.find_each do | s | 
      s.credits = 10
      s.save
    end
  end
end
