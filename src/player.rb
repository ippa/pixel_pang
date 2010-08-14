class Player < GameObject
  traits :velocity, :timer, :collision_detection
  trait :bounding_box, :scale => 0.60, :debug => DEBUG
  
  def initialize(options)
    super
    
    self.input = { :holding_left => :left, 
                   :holding_right => :right, 
                   :space => :fire }
                   
    self.rotation_center = :center_bottom
    
    @speed = 4
    @cooling_down = false
    
    @anim = {}
    @anim[:full] = Animation.new(:file => "walkright.bmp", :size => [42, 42], :delay => 40)
    @anim[:walking] = @anim[:full][0..2]
    @image = @anim[:walking].first
    
    @anim[:fire] = Animation.new(:file => "fire.bmp", :size => [42, 42], :delay => 40)
    
    self.zorder = 40
    self.acceleration_y = 0.50
    cache_bounding_box
  end
  
  def update
  end

  def left
    move(-@speed, 0)
    @image = @anim[:walking].next
    @factor_x = -$window.factor
  end

  def right
    move(@speed, 0)
    @image = @anim[:walking].next
    @factor_x = $window.factor
  end
  
  def move(x, y)
    self.x += x
    self.x = self.previous_x  if $window.current_game_state.game_object_map.from_game_object(self)
    self.x = self.previous_x  if self.bb.left < 0
    self.x = self.previous_x  if self.bb.right > $window.width

    self.y += y
    if $window.current_game_state.game_object_map.from_game_object(self)
      self.stop
      self.y = self.previous_y
    end
  end
  
  def fire   
    return if Laser.size > 0
    #@cooling_down = true; after(200) { @cooling_down = false }
    Laser.create(:x => @x, :y => self.bb.top)
    @image = @anim[:fire].first
  end
  
  def hit_by(object)
    Sound["die.wav"].play
    object.destroy
    Pop.create(:owner => self)
  end
end

class Laser < GameObject
  traits :collision_detection, :timer
  trait :bounding_box, :scale => 0.80, :debug => DEBUG
  
  def setup
    Sound["player_fire.wav"].play(0.2)
    @factor_seed = 0.1
    @image = Image["laser.png"]
    self.zorder = 20
    self.rotation_center(:top_center)

    every(50) { self.mode = (self.mode == :additive) ? :default : :additive }
    every(100) { Star.create(:x => @x, :y => @y) }
    cache_bounding_box
  end
    
  def update
    @factor_seed += 0.5
    @factor_seed = 0 if @factor_seed > Math::PI * 2
    self.factor_x = 1 + Math::sin(@factor_seed)/6
    @y -= 6
  end
  
end

class Star < GameObject
  trait :velocity
  
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