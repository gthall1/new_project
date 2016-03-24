class Purchase < ActiveRecord::Base
  belongs_to :user
  belongs_to :purchase_type

  def is_game
    return self.purchase_type.name == "game"
  end

  def game
    if is_game
        Game.where(id:self.purchase_record_id).first
    end
  end

end
