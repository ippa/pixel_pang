#
# 
#
require 'rubygems'
require 'opengl'

begin
  require '../chingu/lib/chingu'
rescue LoadError
  require 'chingu'
end

include Gosu
include Chingu

require_all 'src/'

class Game < Chingu::Window
  attr_reader :factor, :player
  attr_accessor :levels
  
  def initialize
    #super(screen_width, screen_height, true)
    super(800, 600, false)
    
    self.input = { :esc => :close, :p => Chingu::GameStates::Pause, :f1 => :next_level }
    @factor = 1
    @player = Player.create(:x => 200, :y => $window.height - 40, :zorder => 100)
    
    Sound["pop.wav"]          # <-- lame caching untill chingu gets "cache_media()" or simular
    Sound["player_fire.wav"]  # -""-
    Sound["die.wav"]          # -""-

    @levels = [Level1, Level2, Level3]
    push_game_state(@levels.shift)
  end
  
  def next_level
    push_game_state($window.levels.shift)
  end
end

Game.new.show