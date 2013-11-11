# Copyright (c) 2013 Juan Jose Karam and contributors
#
# MIT License
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


# Almost codes are from Joybox (https://github.com/rubymotion/Joybox)

class CGPoint
  def +(other)
    CGPointMake(self.x + other.x, self.y + other.y)
  end

  def -@
    CGPointMake(- self.x, - self.y)
  end

  def -(other)
    self.+(-other)
  end

  def *(other)
    case other
    when Numeric
      CGPointMake(self.x * other, self.y * other)
    when CGPoint
      CGPointMake(self.x * other.x, self.y * other.y)
    end
  end

  def length
    Math.sqrt(self.x * self.x + self.y * self.y)
  end

  def normalize
    length = self.length
    CGPointMake(self.x / length, self.y / length)
  end

  def to_s
    NSStringFromCGPoint(self)
  end
end
