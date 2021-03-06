class MyScene < SKScene

  attr_accessor :player
  attr_accessor :last_spawn_time_interval
  attr_accessor :last_update_time_interval
  attr_accessor :monsters_destroyed

  PROJECTILE_CATEGORY = 0x1 << 0
  MONSTER_CATEGORY    = 0x1 << 1


  def initWithSize(size)
    super

    self.backgroundColor = SKColor.colorWithRed(1.0, green: 1.0, blue: 1.0, alpha: 1.0)

    self.player = SKSpriteNode.spriteNodeWithImageNamed("player")
    self.player.position = CGPointMake(self.player.size.width / 2, self.frame.size.height / 2)
    self.addChild(self.player)

    self.physicsWorld.gravity = CGVectorMake(0, 0)
    self.physicsWorld.contactDelegate = self

    self.monsters_destroyed = 0

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

    monster.physicsBody = SKPhysicsBody.bodyWithRectangleOfSize(monster.size)
    monster.physicsBody.tap do |body|
      body.dynamic = true
      body.categoryBitMask = MONSTER_CATEGORY
      body.contactTestBitMask = PROJECTILE_CATEGORY
      body.collisionBitMask = 0
    end

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
    lose_action = SKAction.runBlock(lambda {
      reveal = SKTransition.flipHorizontalWithDuration(0.5)
      game_over_scene = GameOverScene.alloc.initWithSize(self.size, won: false)
      self.view.presentScene(game_over_scene, transition: reveal)
    })
    action_move_done = SKAction.removeFromParent
    monster.runAction(SKAction.sequence([action_move, lose_action, action_move_done]))
  end

  def touchesEnded(touches, withEvent: event)
    self.runAction(SKAction.playSoundFileNamed("Sounds/pew-pew-lei.caf", waitForCompletion: false))

    # 1 - Choose one of the touches to work with
    touch = touches.anyObject
    location = touch.locationInNode(self)

    # 2 - Set up initial location of projectile
    projectile = SKSpriteNode.spriteNodeWithImageNamed("projectile")
    projectile.position = self.player.position

    projectile.physicsBody = SKPhysicsBody.bodyWithCircleOfRadius(projectile.size.width / 2)
    projectile.physicsBody.tap do |body|
      body.dynamic = true
      body.categoryBitMask = PROJECTILE_CATEGORY
      body.contactTestBitMask = MONSTER_CATEGORY
      body.collisionBitMask = 0
      body.usesPreciseCollisionDetection = true
    end

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

  # Call when collide cause of self.contactDelegate == self
  def didBeginContact(contact)
    if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask
      first_body, second_body = contact.bodyA, contact.bodyB
    else
      first_body, second_body = contact.bodyB, contact.bodyA
    end

    if (first_body.categoryBitMask & PROJECTILE_CATEGORY != 0) &&
       (second_body.categoryBitMask & MONSTER_CATEGORY != 0)
      self.projectile(first_body.node, didCollideWithMonster: second_body.node)
    end
  end

  def projectile(projectile, didCollideWithMonster: monster)
    projectile.removeFromParent
    monster.removeFromParent
    self.monsters_destroyed += 1
    if self.monsters_destroyed >= 3
      reveal = SKTransition.flipHorizontalWithDuration(0.5)
      game_over_scene = GameOverScene.alloc.initWithSize(self.size, won: true)
      self.view.presentScene(game_over_scene, transition: reveal)
    end
  end

end
