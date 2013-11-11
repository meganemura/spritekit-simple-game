class MyScene < SKScene

  attr_accessor :player
  attr_accessor :last_spawn_time_interval
  attr_accessor :last_update_time_interval

  def initWithSize(size)
    super

    self.backgroundColor = SKColor.colorWithRed(1.0, green: 1.0, blue: 1.0, alpha: 1.0)

    self.player = SKSpriteNode.spriteNodeWithImageNamed("player")
    self.player.position = CGPointMake(self.player.size.width / 2, self.frame.size.height / 2)
    self.addChild(self.player)
    self.last_spawn_time_interval = 0
    self.last_update_time_interval = 0

    self
  end

  # Called before each frame is rendered
  def update(current_time)
    # Handle time delta.
    # If we drop below 60fps, we still want everything to move the same distance.
    time_since_last = current_time - self.last_spawn_time_interval
    self.last_update_time_interval = current_time

    # more than a second since last update
    if time_since_last > 1
      time_since_last = 1.0 / 60.0
      self.last_update_time_interval = current_time
    end

    self.update_with_time_since_last_update(time_since_last)
  end

  def update_with_time_since_last_update(time_since_last)
    self.last_spawn_time_interval += time_since_last
    if self.last_spawn_time_interval > 1
      self.last_spawn_time_interval = 0
      self.add_monster
    end
  end

  def add_monster
    # Create sprite
    monster = SKSpriteNode.spriteNodeWithImageNamed("monster")

    # Determine where to spawn the monster along the Y axis
    min_y = monster.size.height / 2
    max_y = self.frame.size.height - monster.size.height / 2
    range_y = max_y - min_y
    actual_y = rand() * range_y + min_y

    # Create the monster slightly off-screen along the right edge,
    # and along a random position along the Y axis as calculated above
    monster.position = CGPointMake(self.frame.size.width + monster.size.width / 2, actual_y)
    self.addChild(monster)

    # Determine speed of the monster
    min_duration = 2.0
    max_duration = 4.0
    range_duration = max_duration - min_duration
    actual_duration = rand() * range_duration + min_duration

    # Create the actions
    action_move = SKAction.moveTo(CGPointMake(-monster.size.width / 2, actual_y), duration: actual_duration)
    action_move_done = SKAction.removeFromParent
    monster.runAction(SKAction.sequence([action_move, action_move_done]))
  end

  def touchesEnded(touches, withEvent: event)
    # 1 - Choose one of the touches to work with
    touch = touches.anyObject
    location = touch.locationInNode(self)

    # 2 - Set up initial location of projectile
    projectile = SKSpriteNode.spriteNodeWithImageNamed("projectile")
    projectile.position = self.player.position

    # 3 - Determine offset of location to projectile
    offset = location - projectile.position

    # 4 - Bail out if you are shooting down or backwards
    return if offset.x <= 0

    # 5 - OK to add now - we've double checked position
    self.addChild(projectile)

    # 6 - Get the direction of where to shoot
    direction = offset.normalize

    # 7 - Make it shoot far enough to be guaranteed off screen
    shoot_amount = direction * 1000

    # 8 - Add the shoot amount to the current position
    real_dest = shoot_amount + projectile.position

    # 9 - Create the actions
    velocity = 480.0
    real_move_duration = self.size.width / velocity
    action_move = SKAction.moveTo(real_dest, duration: real_move_duration)
    action_move_done = SKAction.removeFromParent
    projectile.runAction(SKAction.sequence([action_move, action_move_done]))
  end
end
