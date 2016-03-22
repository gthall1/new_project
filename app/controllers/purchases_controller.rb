class PurchasesController < ApplicationController
  def create
    @purchase = Purchase.new(purchase_params)

    notice = "Unable to unlock game."
    case @purchase.purchase_type.name
      when 'game'
        if current_user && !current_user.has_purchased_game(@purchase.purchase_record_id) && current_user.credits && current_user.credits >= @purchase.game.credit_cost
          current_user.credits = current_user.credits - @purchase.game.credit_cost
          current_user.pending_credits = 0 if current_user.pending_credits.nil?
          current_user.pending_credits = current_user.pending_credits + @purchase.game.credit_cost
          @purchase.credits_spent = @purchase.game.credit_cost
          @purchase.user_id = current_user.id
          if @purchase.save
            current_user.save
            notice = "You have unlocked #{@purchase.game.name}!"
          end
        end     
    end
    redirect_to root_path, :notice => notice
  end

  private 
    def purchase_params
      params.require(:purchase).permit(:purchase_record_id,:purchase_type_id)
    end
end
