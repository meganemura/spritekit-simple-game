# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/ios'

begin
  require 'bundler'
  Bundler.require
rescue LoadError
end

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'spritekit-simple-game'
  app.frameworks += %w(
    SpriteKit
    AVFoundation
  )
  app.interface_orientations = [:landscape_left]
end
