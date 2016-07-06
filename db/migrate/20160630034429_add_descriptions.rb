class AddDescriptions < ActiveRecord::Migration
  def change
    a = Game.find_by_slug('flappy-pilot')
    a.description = "Flappy Pilot - Help guide the plane navigate through dangerous spikes in our 'Flappy' style game.  The longer you can keep the plane in the air the higher you will score.  Be careful, once you reach a certain distance you'll need to demonstrate even more game skill because the spikes will start to move!  Prove you're the best pilot and prove your skill in Flappy Pilot!"
    a.save

    a = Game.find_by_slug('fall-down')
    a.description = "Guide the ball through the constantly rising platforms. Game Hint: On desktop use your arrow keys keyboard to guide the ball. On mobile use your thumbs on either side of the screen. See how long you can make it in the game as the rising tiles pick up speed."
    a.save    

    a = Game.find_by_slug('2048')
    a.description = "The objective of the game is to get the number 2048 using additions of the number two and its multiples.  Two numbers will be given: usually two number twos, maybe number four.  Move up or down, left or right trying to join two equal numbers.  When two equal numbers touch, they will add up.  By adding numbers you get higher numbers and you approach 2048, which is the goal of the game."
    a.save 

    a = Game.find_by_slug('gold-runner')
    a.description = "Luckee the leprechaun has escaped with his pot of gold.  Help him navigate the obstacles by choosing the right distance for his growing bridges.  Don't fall in the cracks or you will lose.  Highest score wins, and watch out for the little platforms, they can be tricky!"
    a.save 

    a = Game.find_by_slug('tap-color')
    a.description = "Let's see those reflexes!  This fast paced game will make your eyes water and really put you to the test to prove your reaction skills.  Tap on the right color, but don't take too long or you'll be finished.  How long can you last?"
    a.save 

  end

end
