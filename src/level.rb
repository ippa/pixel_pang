class Level < GameState
  attr_reader :floor_height, :game_object_map
  
  def initialize(options = {})
    super
    
    self.input = { :e => :edit, :esc => :exit, :p => GameStates::Pause }
    
    @player = Player.create(:x => 200, :y => $window.height - 100)
    
    @bg1 = Color::BLUE
    @bg2 = Color::CYAN
    
    @from = Color.new(0xFF129CA2)
    @to = Color.new(0xFF1E5D5F)
    
    @floor_height = 40
    @grid = [16,16]
    @floor = Rect.new(0, $window.height - @floor_height, $window.width, @floor_height)
    @file = File.join(ROOT, "levels", self.filename + ".yml")
    load_game_objects(:file => @file)
    
    @game_object_map = GameObjectMap.new(:grid => @grid, :game_objects => Brick.all + Block.all)
  end
  
  def edit
    push_game_state(GameStates::Edit.new(:file => @file, :grid => @grid, :except => [Star, Laser, Player, Ball, TinyBall, MediumBall, SmallBall, Pixel], :debug => true))
  end

  def draw
    super
    #Image["hud.png"].draw(0,0,100)
    fill_gradient(:from => @bg1, :to => @bg2)
    #Image["sunrise_bg.png"].draw(0,0,5)
    fill_gradient(:rect => @floor, :from => @from, :to => @to, :zorder => 10)
  end
  
  def update
    super
        
    @player.each_collision(Pixel) do |player, pixel|
      player.hit_by(pixel)
    end
    
    #
    # Laser colliding with terrain -> destroy
    #
    Laser.all.select { |laser| @game_object_map.at(laser.x, laser.y) }.each do |laser|
      laser.destroy
    end
          
    #
    # Laser colliding with bouncing Pixels
    #
    Laser.each_collision(Pixel) do |laser, pixel|
      pixel.hit_by(laser)
      laser.destroy
    end
      
    #game_objects.destroy_if { |game_object| game_object.outside_window? }
    
    #if Pixel.size == 0
    #  $window.next_level
    #end
    
    $window.caption = "PixelPang! #{self.class} - FPS: #{$window.fps} - Game objects: #{game_objects.size}"
  end
end

class Level1 < Level; end
class Level2 < Level; end
class Level3 < Level; end