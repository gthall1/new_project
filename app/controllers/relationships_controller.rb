class RelationshipsController < ApplicationController
  before_action :check_signed_in

  def create
    user = User.find(params[:followed_id])
    current_user.follow(user)
    respond_to do |format|
      format.html { redirect_to user_path(name:user.name) }
      format.js
    end
  end

  def destroy
    user = Relationship.find(params[:id]).followed
    current_user.unfollow(user)
    respond_to do |format|
      format.html { redirect_to user_path(name:user.name) }
      format.js
    end
  end
end
