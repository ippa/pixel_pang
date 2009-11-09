class Ball < GameObject
  has_trait :velocity
  attr_accessor :radius
  
  def initialize(options)
    super
    
    @default_radius = 50.0
    @direction = options[:direction] || :right
    @radius = options[:radius] || @default_radius
    
    @owner = options[:owner]
    if @owner
      @x = @owner.x - @owner.radius/2
      @y = @owner.y
      @radius = @owner.radius/2
    end

    self.factor = @radius.to_f / @default_radius.to_f # resize image according to @radius
    self.rotation_center(:center)
    
    @acceleration_y  = 0.30  # some gravity
    @velocity_x      =  (@direction == :right) ? 2 : -2
    @max_velocity_y  = 7
    
    @image = Image["ball.png"].retrofy
    @color = Gosu::Color.new(0xFFE95FFA)
  end
  
  def update
    @velocity_y = @max_velocity_y   if @velocity_y > @max_velocity_y
  end
  
  def left
    @x - @radius
  end

  def right
    @x + @radius
  end

  def top
    @y + @radius
  end

  def bottom
    @y + @radius
  end

  def hit_by(object)
    Pop.create(:owner => self)
    
    if @radius > 10
      Ball.create(:owner => self, :direction => :left)
      Ball.create(:owner => self, :direction => :right)
    end
    
    destroy
  end
  
end

class Pop < GameObject
  has_trait :timer
  
  def initialize(options)
    super
    @owner = options[:owner]    
    @x = @owner.x
    @y = @owner.y
    self.factor = @owner.factor
    self.rotation_center(:center)
   
    @image = Image["pop.png"]
    Sound["pop.wav"].play
    after(300) { destroy }
  end
  
  def update
    @angle += 15
  end
end