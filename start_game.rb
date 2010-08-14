#
# 
#
#require 'rubygems'

begin
  raise LoadError if defined?(Ocra)
  require '../chingu/lib/chingu'
rescue LoadError
  #require 'chingu'
end

#$: << File.join(ROOT,"lib")
ENV['PATH'] = File.join(ROOT,"lib") + ";" + ENV['PATH']

include Gosu
include Chingu

DEBUG = false

require_all File.join(ROOT, "src")

exit if defined?(Ocra)

class Game < Chingu::Window
  attr_accessor :levels, :player
  
  def initialize
    super(800, 600, false)
    
    retrofy
    self.input = { :esc => :close, :p => Chingu::GameStates::Pause, :f1 => :next_level }
    self.factor = 2
    
    @player = Player.create(:x => 200, :y => $window.height - 100)
    
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