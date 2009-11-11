
class Brick < GameObject
  has_trait :collision_detection
  
  def initialize(options)
    super
    @image = @image || Image["brick.bmp"].retrofy
    
    self.rotation_center(:top_left)
    self.factor = 2
    @bounding_box = Rect.new(@x, @y, @image.width*self.factor, @image.height*self.factor)
  end
end

class SmallBrick < Brick
  def initialize(options)
    @image = Image["small_brick.bmp"]
    super
  end
end