class Pixel < GameObject
  traits :velocity, :collision_detection, :timer
  trait :bounding_box, :debug => false
  attr_reader :power
    
  def initialize(options)
        
    super
    
    @direction = options[:direction] || :right
        
    self.rotation_center  = :center
    self.acceleration_y   = 0.30
    self.velocity_x       =  (@direction == :right) ? 2 : -2
    self.max_velocity     = 20
    self.image = Image["#{self.filename}.bmp"]
    self.factor = 4

    cache_bounding_box
  end
     
  def bounce_vertical
    self.y = self.previous_y
    self.velocity_y = self.velocity_y > 0 ? -5-(@power*0.40) : self.velocity_y.abs
  end
  
  def bounce_horizontal
    self.x = self.previous_x
    self.velocity_x = -self.velocity_x    
  end

  #
  # Trait 'velocity' will always end up calling move(x, y)
  # We hijack it with our own logic and collision detection
  #
  def move(x, y)
    self.x += x
    self.bounce_horizontal  if self.bb.left < 0 
    self.bounce_horizontal  if self.bb.right > $window.width    
    self.bounce_horizontal  if parent.game_object_map.from_game_object(self)
      
    self.y += y
    self.bounce_vertical    if parent.game_object_map.from_game_object(self)
  end
  
  def hit_by(object)
    if @power == 20
      SmallPixel.create(:direction => :left, :x => self.x, :y => self.y)
      SmallPixel.create(:direction => :right, :x => self.x, :y => self.y)
      4.times { Pop.create(:owner => self) }
    elsif @power == 10
      TinyPixel.create(:direction => :left, :x => self.x, :y => self.y)
      TinyPixel.create(:direction => :right, :x => self.x, :y => self.y)
      4.times { Pop.create(:owner => self) }      
    else
      2.times { Pop.create(:owner => self) }
    end
    
    destroy
  end
  
end

class BigPixel < Pixel
  def setup
    self.zorder = 30
    @power = 20
  end
end

class SmallPixel < Pixel
  def setup
    self.zorder = 31
    @power = 10
  end
end

class TinyPixel < Pixel
  def setup
    self.zorder = 32
    @power = 5
  end  
end
  
class Pop < GameObject
  traits :timer, :velocity
  
  def initialize(options)
    super
    @owner = options[:owner]    
    @angle_velocity = rand(10)
    self.attributes = @owner.attributes
    self.image = @owner.image
    self.velocity_y = -5 + rand(2)
    self.velocity_x = (-5 + rand(10)) * 2
    self.acceleration_y = 0.50
    self.mode = :additive
    self.color = Color::WHITE
    self.alpha = 100
    Sound["pop.wav"].play(0.2)
  end
  
  def update
    self.angle += @angle_velocity
    self.alpha -= 1
    destroy if self.alpha == 0
  end
end