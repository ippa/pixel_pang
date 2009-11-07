class Ball < GameObject
  has_trait :velocity
  attr_accessor :radius
  
  def initialize(options)
    super
    @radius = options[:radius] || 50
    @direction = options[:direction] || :right
    
    self.rotation_center(:center)
    @acceleration_y  = 0.5  # some gravity
    @velocity_x      =  (@direction == :right) ? 2 : -2
    @max_velocity_y  = 10
    
    @image = Image["ball.png"].retrofy
    @color = Gosu::Color.new(0xFFE95FFA)
    self.factor = $window.factor
  end
  
  def update
    @velocity_y = @max_velocity_y   if @velocity_y > @max_velocity_y
  end
  
  def hit_by(object)
    if @size > 1
      Pop.create(:x => @x, :y => @y)
      Ball.create(:x => @x, :y => @y, :size => @size/2, :direction => :left)
      Ball.create(:x => @x, :y => @y, :size => @size/2, :direction => :right)
    end
    destroy
  end
  
end

class Pop < GameObject
  has_trait :timer
  def initialize(options)
    super
    #@image = Image["pop"]
    after(200) { :destroy }
  end
end