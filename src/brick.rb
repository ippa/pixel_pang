
class Brick < GameObject
  has_trait :collision_detection
  has_trait :bounding_box, :debug => true
  
  def initialize(options)
    super
    @image = @image || Image["brick.bmp"]
    self.rotation_center = :top_left
    self.factor = 3
  end
end

#
# Warning, trait bounding_box doesn't inherit well.
#
class SmallBrick < Brick
  ##has_trait :bounding_box, :debug => true
  def initialize(options)
    @image = Image["small_brick.bmp"]
    super
  end
end