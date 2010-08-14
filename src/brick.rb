class Brick < GameObject
  traits :bounding_box, :collision_detection
  
  def setup
    @image ||= Image["#{self.filename}.bmp"]
    self.rotation_center = :top_left
    cache_bounding_box
  end
end

class LeftBrick < Brick; end
class RightBrick < Brick; end
