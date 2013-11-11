class GameOverScene < SKScene
  alias_method :super_initWithSize, :initWithSize
  def initWithSize(size, won: won)
    super_initWithSize(size)

    self.backgroundColor = SKColor.colorWithRed(1.0, green: 1.0, blue: 1.0, alpha: 1.0)

    message = won ? "You Won!" : "You Lose :["

    label = SKLabelNode.labelNodeWithFontNamed("Chalkduster")
    label.text = message
    label.fontSize = 40
    label.fontColor = SKColor.blackColor
    label.position = CGPointMake(self.size.width / 2, self.size.height / 2)
    self.addChild(label)

    self.runAction(
      SKAction.sequence([
        SKAction.waitForDuration(3.0),
        SKAction.runBlock(lambda {
          reveal = SKTransition.flipHorizontalWithDuration(0.5)
          my_scene = MyScene.alloc.initWithSize(self.size)
          self.view.presentScene(my_scene, transition: reveal)
        }),
      ])
    )
  end

end
