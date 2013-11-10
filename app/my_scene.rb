class MyScene < SKScene

  attr_accessor :player

  def initWithSize(size)
    super

    self.backgroundColor = SKColor.colorWithRed(1.0, green: 1.0, blue: 1.0, alpha: 1.0)

    self.player = SKSpriteNode.spriteNodeWithImageNamed("player")
    self.player.position = CGPointMake(self.player.size.width / 2, self.frame.size.height / 2)
    self.addChild(self.player)

    self
  end

  def touchesBegan(touches, withEvent: event)
    touches.each do |touch|
      location = touch.locationInNode(self)
      sprite = SKSpriteNode.spriteNodeWithImageNamed("Spaceship")
      sprite.position = location
      action = SKAction.rotateByAngle(Math::PI, duration: 1)
      sprite.runAction(SKAction.repeatActionForever(action))
      self.addChild(sprite)
    end
  end

  def update(current_time)
    # Called before each frame is rendered
  end
end
