class Level < GameState
  def initialize(options = {})
    super
    #self.input = { :e => Chingu::GameStates::Edit }
    
    @bg1 = Color.new(0xFF97E5E8)
    @bg2 = Color.new(0xFFF49595)
    
    @from = Color.new(0xFF129CA2)
    @to = Color.new(0xFF1E5D5F)
    
    @floor_height = 40
    @floor = Rect.new(0, $window.height - @floor_height, $window.width, @floor_height)
  end
  
  def draw
    super
    fill_gradient(:from => @bg1, :to => @bg2)
    fill_gradient(:rect => @floor, :from => @from, :to => @to)
  end
  
  def update
    super
    
    Bullet.each_radius_collision(Ball) do |bullet, ball|
      ball.hit_by(bullet)
      bullet.destroy
    end
    
    Ball.all.each do |ball|
      
      if ball.bottom > ($window.height - @floor_height)
        ball.velocity_y = -7 - ball.radius * 0.15
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
    
    $window.caption = "Pang! FPS: #{$window.fps} - Game objects: #{game_objects.size}"
  end
end


class Level1 < Level
  def setup
    Ball.create(:x => 100, :y => 50)
    Ball.create(:x => 300, :y => 100)
    Ball.create(:x => 500, :y => 200)
  end
end