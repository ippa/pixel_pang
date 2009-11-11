class Level < GameState
  attr_reader :floor_height
  
  def initialize(options = {})
    super
    
    if defined?(Chingu::GameStates::Edit)
      self.input = { :e => GameStates::Edit.new(:grid => [16, 16], :classes => [Brick, SmallBrick]) }
    end
    
    @bg2 = Color.new(0xFFFF0000)
    @bg1 = Color.new(0xFF000000)
    
    @from = Color.new(0xFF129CA2)
    @to = Color.new(0xFF1E5D5F)
    
    @floor_height = 40
    @floor = Rect.new(0, $window.height - @floor_height, $window.width, @floor_height)
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
    
    #Bullet.each_radius_collision(Ball) do |bullet, ball|
    #  ball.hit_by(bullet)
    #  bullet.destroy
    #end
    
    #
    # Check for Player <-> Ball collisions
    #
    $window.player.each_radius_collision(Ball) do |player, ball|
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
      
      Brick.all.each do |brick|
        if  brick.bounding_box.collide_point?(ball.left, ball.y) || brick.bounding_box.collide_point?(ball.right, ball.y)
          ball.velocity_x = -ball.velocity_x
        elsif brick.bounding_box.collide_point?(ball.x, ball.top) || brick.bounding_box.collide_point?(ball.x, ball.bottom)
          ball.bounce_vertical
        end
      end
      
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

class Level1 < Level
  def setup
    count = game_objects.size
  
    load_game_objects
    
    # If no game object where loaded, create some.
    if count == game_objects.size
      MediumBall.create(:x => 300, :y => 100)
      MediumBall.create(:x => 500, :y => 200)
    
      Brick.create(:x => 32, :y => 400)
      Brick.create(:x => 96, :y => 400)
      SmallBrick.create(:x => 160, :y => 400)
    end
  end
end

class Level2 < Level
  def setup
    count = game_objects.size
    
    load_game_objects
    
    # If no game object where loaded, create some.
    if count == game_objects.size
      Ball.create(:x => 200, :y => 50)
      Ball.create(:x => 300, :y => 100)
      Ball.create(:x => 500, :y => 200)
    
      Brick.create(:x => 32, :y => 400)
      Brick.create(:x => 96, :y => 400)
      SmallBrick.create(:x => 160, :y => 400)
    end
  end
end

class Level3 < Level
  def setup
    count = game_objects.size
    
    load_game_objects
    
    # If no game object where loaded, create some.
    if count == game_objects.size
      Ball.create(:x => 300, :y => 50)
      MediumBall.create(:x => 300, :y => 50)
      MediumBall.create(:x => 350, :y => 50)
      MediumBall.create(:x => 400, :y => 50)
      SmallBall.create(:x => 500, :y => 50)
      TinyBall.create(:x => 550, :y => 50)
      TinyBall.create(:x => 600, :y => 50)
    
      Brick.create(:x => 32, :y => 400)
      Brick.create(:x => 96, :y => 400)
      SmallBrick.create(:x => 160, :y => 400)
    end
  end
end
