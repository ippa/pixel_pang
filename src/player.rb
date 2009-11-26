class Player < Chingu::GameObject
  has_traits :velocity, :timer, :collision_detection
  has_trait :bounding_circle, :debug => true
  
  def initialize(options)
    super
    
    self.input = { :holding_left => :left, 
                   :holding_right => :right, 
                   :space => :fire }
                   
    self.rotation_center = :center_bottom
    
    # @radius = 25
    @speed = 2.5
    @cooling_down = false
    self.factor = $window.factor
    @image = Image["player.png"]
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
    return if Laser.size > 0
    #@cooling_down = true; after(200) { @cooling_down = false }
    Laser.create(:x => @x, :y => $window.height - $window.current_game_state.floor_height)
  end
  
  def hit_by(object)
    Sound["die.wav"].play
    object.destroy
    Pop.create(:owner => self)
    #push_game_state(Die)
  end
end

class Laser < GameObject
  has_traits :collision_detection, :timer
  
  def initialize(options)
    super
    Sound["player_fire.wav"].play(0.2)
    @factor_seed = 0.1
    @image = Image["laser.png"]
    @zorder = 10
    self.rotation_center(:top_center)
    every(100) { Star.create(:x => @x, :y => @y) }
  end
    
  def update
    @factor_seed += 0.5
    @factor_seed = 0 if @factor_seed > Math::PI * 2
    self.factor_x = 1 + Math::sin(@factor_seed)/6
    @y -= 7 
  end
  
end


class Star < GameObject
  has_traits :velocity
  
  def initialize(options)
    super
    @image = Image["pop.png"]
    self.factor = 0.3
    @velocity_y = 2
    @velocity_x = 3 - rand(6)
  end
  
  def update
    #
    # Fall down rotating and fade out .. destroy when faded.
    #
    self.angle += 5
    self.alpha -= 10
    destroy if self.alpha < 10
  end
end