class Player < Chingu::GameObject
  has_trait :velocity, :retrofy, :timer, :collision_detection
  
  def initialize(options)
    super
    
    self.input = { :holding_left => :left, 
                   :holding_right => :right, 
                   :space => :fire
                 }
    self.rotation_center(:center_bottom)
    
    @radius = 25
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
  has_trait :collision_detection
  attr_reader :head, :body
  
  def initialize(options)
    super
    Sound["player_fire.wav"].play(0.2)
    @factor_seed = 0.1
    @image = Image["laser.png"]
    @zorder = 10
    self.rotation_center(:top_center)
    #@head = GameObject.create(:x => @x, :y => @y, :image => "bullet_head.png", :zorder => 2, :rotation_center => :top_center)
    #@body = GameObject.create(:x => @x, :y => @y, :image => "bullet_body.png", :zorder => 1, :rotation_center => :top_center)
  end
    
  def update
    @factor_seed += 0.5
    @factor_seed = 0 if @factor_seed > Math::PI * 2
    self.factor_x = 1 + Math::sin(@factor_seed)/6
    @y -= 5
    
    #@body.factor = 1 + Math::sin(@factor_seed)/5
    #@head.y -= 5
    #@body.y -= 5
    
  end
  
  #def destroy
  #  super
  #  @head.destroy
  #  @body.destroy
  #end
  
  #def draw
  #  @body.draw
  #  @head.draw
  #end
  
end