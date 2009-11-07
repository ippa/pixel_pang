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
    
    Ball.all.each do |ball|
      
      if ball.y > ($window.height - @floor_height - ball.radius)
        ball.velocity_y = -20
      end
      
      if ball.x - ball.radius < 0 
        ball.velocity_x = -ball.velocity_x
        ball.x = ball.radius
      elsif ball.x + ball.radius > $window.width
        ball.velocity_x = -ball.velocity_x
        ball.x = $window.width - ball.radius
      end
      
    end
    
  end
end


class Level1 < Level
  def setup
    Ball.create(:x => 100, :y => 50)
    Ball.create(:x => 300, :y => 100)
    Ball.create(:x => 500, :y => 200)
  end
end