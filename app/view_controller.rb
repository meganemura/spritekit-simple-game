class ViewController < UIViewController
  def viewWillLayoutSubviews
    super

    if self.view.class != SKView
      # Configure the view.
      sk_view = SKView.alloc.init
      sk_view.bounds = self.view.bounds
      sk_view.showsFPS = true
      sk_view.showsNodeCount = true

      # Create and configure the scene.
      scene = MyScene.sceneWithSize(sk_view.bounds.size)
      scene.scaleMode = SKSceneScaleModeAspectFill

      # Present the scene.
      sk_view.presentScene(scene)

      self.view = sk_view
    end
  end

  def shouldAutorotate
    true
  end

  def supportedInterfaceOrientations
    if UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPhone
      UIInterfaceOrientationMaskAllButUpsideDown
    else
      UIInterfaceOrientationMaskAll
    end
  end

  def didReceiveMemoryWarning
    super
    # Release any cached data, images, etc that aren't in use.
  end
end
