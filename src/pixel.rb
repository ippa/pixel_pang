class Pixel < GameObject
  traits :velocity, :collision_detection, :timer
  trait :bounding_box, :debug => false
  
  def initialize(options)
    @image = Image["big_pixel.png"]
    
    super
    
    @direction = options[:direction] || :right
    @size = 20
    
    self.rotation_center  = :top_left
    self.acceleration_y   = 0.30
    self.velocity_x       =  (@direction == :right) ? 2 : -2
    self.max_velocity     = 20
    
    cache_bounding_box
  end
     
  def bounce_vertical
    self.y = self.previous_y
    v = 5 + (@size * 0.20)
    self.velocity_y = self.velocity_y > 0 ? -v : v    
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
    self.bounce_vertical    if self.bb.bottom > ($window.height - parent.floor_height)
  end
  
  def hit_by(object)
    Pop.create(:owner => self)
    
    #if bouncyness > 10
    #  Ball.create(:owner => self, :direction => :left)
    #  Ball.create(:owner => self, :direction => :right)
    #end
    
    destroy
  end
  
end

class BigPixel < Pixel
  def setup
    self.factor = 3
    cache_bounding_box
  end
end

class SmallPixel < Pixel
  def setup
    self.factor = 2
    cache_bounding_box
  end
end

class TinyPixel < Pixel
  def setup
    self.factor = 1
    cache_bounding_box
  end
end

class Pop < GameObject
  trait :timer
  
  def initialize(options)
    super
    @owner = options[:owner]    
    @x = @owner.x
    @y = @owner.y
    self.factor = @owner.factor
    self.rotation_center = :center
   
    @image = Image["pop.png"]
    Sound["pop.wav"].play
    after(300) { destroy }
  end
  
  def update
    @angle += 15
  end
end