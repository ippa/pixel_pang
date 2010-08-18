class Block < GameObject
  traits :bounding_box, :collision_detection
  
  def setup
    @image ||= Image["#{self.filename}.bmp"] rescue Image["#{self.filename}.png"]
    self.rotation_center = :top_left
    cache_bounding_box
  end
end

class GrassBlock < Block; end

class GrassTest < Block; end

