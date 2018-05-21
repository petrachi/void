class Point
  attr_accessor :q

  def self.from_dump dump
    new *dump.split(':').map(&:to_f)
  end

  def initialize *coords
    self.q = Quaternion 0, *coords
  end

  def dump
    [x, y, z].join(":")
  end

  def eql? other
    q == other.q
  end
  alias :== :eql?

  def hash
    [x, y, z].hash
  end

  def x
    q.imag[0]
  end

  def y
    q.imag[1]
  end

  def z
    q.imag[2]
  end

  def translate! other
    self.q = q + other
  end

  def rotate! h, origin
    self.q = h * (q + origin.conjugate) * h.inverse + origin
  end

  def scale! length, origin
    self.q = (origin.conjugate + q) * length + origin
  end

  def unify! origin
    self.q = (origin.conjugate + q).unify + origin
  end

  def q= other
    @q = other.round(4)
  end

  def proj q
    z >= q.imag[2] or raise RangeError, 'the "z" coordinates of self must be >= to the "z" coordinate of the perspective point'

    t = -z / (z - q.imag[2])
    nx = x + ((x - q.imag[0]) * t)
    ny = y + ((y - q.imag[1]) * t)

    self.class.new nx, ny, 0
  end

  def midpoint *other
    Point.new(
      (x + other.map(&:x).reduce(&:+)) / (other.size + 1.0),
      (y + other.map(&:y).reduce(&:+)) / (other.size + 1.0),
      (z + other.map(&:z).reduce(&:+)) / (other.size + 1.0),
    )
  end
end
