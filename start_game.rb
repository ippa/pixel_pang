#
# 
#
require 'rubygems'
require 'opengl'
require 'chingu'
#require '../chingu/lib/chingu'

include Gosu
include Chingu

require_all 'src/'


class Game < Chingu::Window
  attr_reader :factor, :player
  
  def initialize
    super(1000, 700)
    self.input = { :esc => :close, :p => Chingu::GameStates::Pause }
    @factor = 1
    @player = Player.create(:x => 200, :y => 660, :zorder => 100, :paused => true)

    push_game_state(Level1)
  end
end

Game.new.show