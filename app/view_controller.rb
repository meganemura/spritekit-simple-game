class ViewController < UIViewController

  attr_accessor :backgroundMusicPlayer

  def loadView
    bounds = UIScreen.mainScreen.bounds
    self.view = SKView.alloc.initWithFrame(bounds)
  end

  def viewWillLayoutSubviews
    super

    error = Pointer.new(:object)
    background_music_url = NSBundle.mainBundle.URLForResource("Sounds/background-music-aac", withExtension: "caf")
    self.backgroundMusicPlayer = AVAudioPlayer.alloc.initWithContentsOfURL(background_music_url, error: error)
    self.backgroundMusicPlayer.numberOfLoops = -1
    self.backgroundMusicPlayer.prepareToPlay
    self.backgroundMusicPlayer.play

    # Configure the view.
    sk_view = self.view
    unless sk_view.scene
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
