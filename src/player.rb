class Player < Chingu::GameObject
  has_trait :velocity, :retrofy, :timer
  
  def initialize(options)
    super
    
    self.input = { :holding_left => :left, 
                   :holding_right => :right, 
                   :space => :fire
                 }
    self.rotation_center(:center_bottom)
    
    @speed = 2.5
    @cooling_down = false
    self.factor = $window.factor
    @image = Image["player.png"].retrofy
  end

  def left
    @x -= @speed 
    @x += @speed  if outside_window?
  end

  def right
    @x += @speed
    @x -= @speed  if outside_window?    
  end
  
  def fire   
    return if @cooling_down
    
    @cooling_down = true
    after(200) { @cooling_down = false }
    
    Bullet.create(:x => @x, :y => @y)
  end
end

class Bullet < GameObject
  has_trait :collision_detection
  
  def initialize(options)
    super
    @image = Image["ball.png"]
    self.factor = 0.1
    @radius = 5
    Sound["player_fire.wav"].play(0.2)
  end
  
  def update
    @y -= 10
  end
end
