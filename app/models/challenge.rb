class Challenge < ActiveRecord::Base
  belongs_to :user, :class_name => 'User'
  belongs_to :challenged_user, :class_name => 'User'
  belongs_to :winner, :class_name => 'User'
  belongs_to :game
end
