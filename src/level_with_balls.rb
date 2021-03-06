class BallLevel < GameState
  attr_reader :floor_height
  
  def initialize(options = {})
    super
    
    if defined?(Chingu::GameStates::Edit)
      self.input = { :e => :edit }
    end
    
    @bg2 = Color.new(0xFFFF0000)
    @bg1 = Color.new(0xFF000000)
    
    @from = Color.new(0xFF129CA2)
    @to = Color.new(0xFF1E5D5F)
    
    @floor_height = 40
    @floor = Rect.new(0, $window.height - @floor_height, $window.width, @floor_height)
    @file = File.join(ROOT, "levels", self.filename + ".yml")
    load_game_objects(:file => @file)
  end
  
  def edit
    push_game_state(GameStates::Edit.new(:file => @file, :grid => [16, 16], :except => [Star, Laser, Player, Ball, TinyBall, MediumBall, SmallBall, Pixel], :debug => true))
  end
  
  def draw
    super
    #Image["hud.png"].draw(0,0,100)
    Image["sunrise_bg.png"].draw(0,0,5)
    fill_gradient(:from => @bg1, :to => @bg2)
    fill_gradient(:rect => @floor, :from => @from, :to => @to, :zorder => 10)
  end
  
  def update
    super
    
    #
    # Later on when we have ordinary bullets ...
    #
       
    #
    # Check for Player <-> Ball collisions
    #
    #$window.player.each_bounding_circle_collision(Ball) do |player, ball|
    
    $window.player.each_collision(Ball) do |player, ball|      
      player.hit_by(ball)
    end
    
    Laser.all.each do |laser|
      Brick.all.each do |brick|
        if brick.bounding_box.collide_point?(laser.x, laser.y)
          laser.destroy
        end
      end
    end
    
    #
    # Iterate through all balls, collide them with lasers, walls and floors!
    #
    Ball.all.each do |ball|
      
      ball.each_collision(Brick) do |ball, brick|
        # Basicly invert Y-axis velocity
        ball.bounce_vertical
        
        #ball_to_roof = distance(ball.x, ball.y, brick.bounding_box.centerx, brick.bounding_box.y)
        #ball_to_side = distance(ball.x, ball.y, brick.bounding_box.centerx, brick.bounding_box.y)
        
        #if ball.bottom+2 > brick.bb.top || ball.top-2 < brick.bb.bottom
        #  ball.velocity_x = -ball.velocity_x
        #end
        
        # on it's way down, bounce upwards!
        ball.y = brick.bounding_box.top - ball.radius - 2   if ball.velocity_y < 0

        # on it's way up, bounce downwards!
        ball.y = brick.bounding_box.bottom + ball.radius + 2   if ball.velocity_y > 0
      end
      
      #Brick.all.each do |brick|
      #  if brick.bounding_box.collide_point?(ball.left, ball.y) || brick.bounding_box.collide_point?(ball.right, ball.y)
      #    ball.velocity_x = -ball.velocity_x
      #  elsif brick.bounding_box.collide_point?(ball.x, ball.top) || brick.bounding_box.collide_point?(ball.x, ball.bottom)
      #    ball.bounce_vertical
      #  end
      #end
      
      Laser.all.each do |laser|
        if ball.bottom > laser.y && ball.left < laser.x && ball.right > laser.x
          ball.hit_by(laser)
          laser.destroy
        end
      end
      
      if ball.bottom > ($window.height - @floor_height)
        ball.bounce_vertical
      end
      
      if ball.left < 0 
        ball.velocity_x = -ball.velocity_x
        ball.x = ball.radius
      elsif ball.right > $window.width
        ball.velocity_x = -ball.velocity_x
        ball.x = $window.width - ball.radius
      end
      
    end
    
    game_objects.destroy_if { |game_object| game_object.outside_window? }
    
    if Ball.size == 0
      $window.next_level
    end
    
    $window.caption = "Pang! #{self.class} - FPS: #{$window.fps} - Game objects: #{game_objects.size}"
  end
end

class BallLevel1 < BallLevel; end
class BallLevel2 < BallLevel; end
class BallLevel3 < BallLevel; end

#class Level1 < Level
#  def setup
    #count = game_objects.size
  
    #load_game_objects
    
    # If no game object where loaded, create some.
    #if count == game_objects.size
 #     Ball.create(:x => 200, :y => 50)
 #     MediumBall.create(:x => 300, :y => 100)
 #     MediumBall.create(:x => 500, :y => 200)
    
 #     Brick.create(:x => 32, :y => 400)
 #     Brick.create(:x => 96, :y => 400)
 #     SmallBrick.create(:x => 160, :y => 400)
    #end
#  end
#end

#class Level2 < Level
#  def setup
#    count = game_objects.size
#    
#    load_game_objects

#    Ball.create(:x => 200, :y => 50)
#    Ball.create(:x => 300, :y => 100)
#    Ball.create(:x => 500, :y => 200)
    
    # If no game object where loaded, create some.
#    if count == game_objects.size
#      Brick.create(:x => 32, :y => 400)
#      Brick.create(:x => 96, :y => 400)
#      SmallBrick.create(:x => 160, :y => 400)
#    end
#  end
#end

#class Level3 < Level
#  def setup
#    count = game_objects.size
#    
#    load_game_objects
    
    # If no game object where loaded, create some.
#    if count == game_objects.size
#      Ball.create(:x => 300, :y => 50)
#      MediumBall.create(:x => 300, :y => 50)
#      MediumBall.create(:x => 350, :y => 50)
#      MediumBall.create(:x => 400, :y => 50)
#      SmallBall.create(:x => 500, :y => 50)
#      TinyBall.create(:x => 550, :y => 50)
#      TinyBall.create(:x => 600, :y => 50)
#    
#      Brick.create(:x => 32, :y => 400)
#      Brick.create(:x => 96, :y => 400)
#      SmallBrick.create(:x => 160, :y => 400)
#    end
#  end
#end
