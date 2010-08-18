class Level < GameState
  trait :timer
  attr_reader :game_object_map, :player
  
  def initialize(options = {})
    super
    
    @player = Player.create(:x => $window.width/2, :y => $window.height - 75)    
  end
  
  def setup
    self.input = { :e => :edit, :esc => MenuState, :p => GameStates::Pause }
    
    @bg1 = Color::BLUE
    @bg2 = Color::CYAN
    @from = Color.new(0xFF129CA2)
    @to = Color.new(0xFF1E5D5F)
    @grid = [16,16]
    
    game_objects.select { |game_object| !game_object.is_a? Player }.each { |game_object| game_object.destroy }
    @file = File.join(ROOT, "levels", self.filename + ".yml")
    load_game_objects(:file => @file)
    
    if Block.size == 0
      puts "* Loading boiler-plate level!"
      load_game_objects(:file => File.join(ROOT, "levels", "empty_level.yml"))
    end
    
    @game_object_map = GameObjectMap.new(:grid => @grid, :game_objects => Brick.all + Block.all)
    
    game_objects.pause!
    after(1000) { game_objects.unpause! }
  end
  
  def edit
    push_game_state(GameStates::Edit.new(:file => @file, :grid => @grid, :except => [Star, Laser, Player, Ball, TinyBall, MediumBall, SmallBall, Pixel, ScoreText], :debug => true))
  end

  def draw
    super
    #Image["hud.png"].draw(0,0,100)
    fill_gradient(:from => @bg1, :to => @bg2)
    #Image["sunrise_bg.png"].draw(0,0,5)
  end
  
  def update
    super
        
    @player.each_collision(Pixel) do |player, pixel|
      player.hit_by(pixel)
      $window.lives -= 1
      during(500) { @player.mode = (@player.mode == :default) ? :additive : :default }
      
      game_objects.pause!
      @player.collidable = false
      after(500) { switch_game_state(self.class) }   # Restart level
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
      $window.score += pixel.power
      ScoreText.create(pixel.power, :x => pixel.x, :y => pixel.y)
      laser.destroy
    end
      
    #game_objects.destroy_if { |game_object| game_object.outside_window? }
    
    if Brick.size > 0 && Pixel.size == 0
      $window.next_level
    end
    
    $window.caption = "PixelPang - #{self.class}! Score: #{$window.score}. FPS: #{$window.fps} - Pixels: #{Pixel.size}"
  end
end

class Level1 < Level; end
class Level2 < Level; end
class Level3 < Level; end
class Level4 < Level; end
class Level5 < Level; end
class Level6 < Level; end
class Level7 < Level; end
class Level8 < Level; end
class Level9 < Level; end
class Level10 < Level; end

class ScoreText < Text
  traits :velocity
  
  def setup
    self.velocity_y = -0.5
  end
  
  def update
    self.alpha -= 2
    destroy if self.alpha == 0
  end
  
end

class MenuState < GameState
  def setup
    SimpleMenu.create(
      :menu_items => {"Start Game" => :start_game, "HighScores" => HighScoreState, "Quit" => :exit}, 
      :size => 20,
      :factor => 4
    )
    
    $window.reset_game
  end

  def start_game
    $window.next_level
  end
end

class HighScoreState < GameState
end

class Intro < GameState
  def setup
  end
  
  def draw
    previous_game_state.draw
  end
end