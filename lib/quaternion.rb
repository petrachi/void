require 'mathn'

def Quaternion *args
  if args[0].is_a? Quaternion
    args[0]
  elsif args[0].is_a? Numeric and args[1].is_a? Vector
    Quaternion.new args[0], *args[1]
  else
    Quaternion.new *args
  end
end

class Quaternion
  attr_accessor :a, :b, :c, :d

  def initialize a=0, b=0, c=0, d=0
    @a = a
    @b = b
    @c = c
    @d = d
  end

  def real
    @a
  end

  def imag
    @imag ||= Vector[@b,@c,@d]
  end
  alias :imaginary :imag

  def length
    @length ||= Math::sqrt( @a**2 + @b**2 + @c**2 + @d**2 )
  end

  def conj
    @conj ||= Quaternion.new( @a, -@b, -@c, -@d )
  end
  alias :conjugate :conj

  def inverse
    @inverse ||= conj / length**2
  end

  def unify
    @unify ||= self / length
  end

  def + other
    Quaternion.new( @a+other.a, @b+other.b, @c+other.c, @d+other.d )
  end

  def - other
    Quaternion.new( @a-other.a, @b-other.b, @c-other.c, @d-other.d )
  end

  def * other
    if other.is_a? Quaternion
      Quaternion.new(
        @a*other.a - @b*other.b - @c*other.c - @d*other.d,
        @a*other.b + @b*other.a + @c*other.d - @d*other.c,
        @a*other.c - @b*other.d + @c*other.a + @d*other.b,
        @a*other.d + @b*other.c - @c*other.b + @d*other.a
      )
    else
      Quaternion.new( @a*other, @b*other, @c*other, @d*other )
    end
  end

  def / other
    if other.is_a? Quaternion
      self * other.inverse
    else
      self * (1/other)
    end
  end

  def == other
    if other.is_a? Quaternion
      @a == other.a and @b == other.b and @c == other.c and @d == other.d
    else
      false
    end
  end

  def round ndigits=0
    Quaternion.new(
      @a.round(ndigits),
      @b.round(ndigits),
      @c.round(ndigits),
      @d.round(ndigits)
    )
  end

  def to_s
    "#{@a} + #{@b}i + #{@c}j + #{@d}k"
  end
end
