#
# 
#
require 'rubygems'
require 'opengl'

begin
  require '../chingu/lib/chingu'
rescue
  require 'chingu'
end

include Gosu
include Chingu

require_all 'src/'


class Game < Chingu::Window
  attr_reader :factor, :player
  
  def initialize
    #super(screen_width, screen_height, true)
    super(800, 600, false)
    
    self.input = { :esc => :close, :p => Chingu::GameStates::Pause }
    @factor = 1
    @player = Player.create(:x => 200, :y => $window.height - 40, :zorder => 100)
    
    Sound["pop.wav"]          # <-- lame caching untill chingu gets "cache_media()" or simular
    Sound["player_fire.wav"]  # -""-
    Sound["die.wav"]          # -""-
    
    push_game_state(Level1)
  end
end

Game.new.show