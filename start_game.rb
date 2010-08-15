#
# 
#

begin
  raise LoadError if defined?(Ocra)
  require '../chingu/lib/chingu'
rescue LoadError
  #require 'chingu'
end

#$: << File.join(ROOT,"lib")
ENV['PATH'] = File.join(ROOT,"lib") + ";" + ENV['PATH']
require 'yaml'

include Gosu
include Chingu

DEBUG = false

require_all File.join(ROOT, "src")

exit if defined?(Ocra)

class Game < Chingu::Window
  attr_accessor :levels
  
  def initialize
    super(800, 600, false)
    
    retrofy
    self.factor = 2
    self.input = { :tab => :next_level }
    
    #gamercv = YAML.load_file(File.join(ROOT, "gamercv.yml"))
    #@high_score_list = OnlineHighScoreList.new(:game_id => 3, :login => gamercv["login"], :password => gamercv["password"], :limit => 10)
    #data = {:name => "BETA-TEST", :score => 667, :text => "Testing the high score list." }
    #position = @high_score_list.add(data)
    #puts "got position: #{position}"
    
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