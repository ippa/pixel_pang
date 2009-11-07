class Player < Chingu::GameObject
  has_trait :velocity, :retrofy, :timer
  
  def initialize(options)
    super
    
    self.input = { :holding_left => :left, 
                   :holding_right => :right, 
                   :space => :fire
                 }
    self.rotation_center(:center_bottom)

    #@anim = nil
    #@anim = Chingu::Animation.new(:file => "media/player.png", :size => [18,29], :delay => 40).retrofy
    #@image = @anim.first
    @speed = 2.5
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
    
  end

  def update
  end
end
