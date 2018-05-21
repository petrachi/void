class Point
  attr_accessor :q, :options

  def self.from_attributes attributes
    attributes.symbolize_keys!
    point = new x: 0, y: 0, z: 0, **attributes.except(:q)
    point.q = Quaternion(attributes[:q])
    point
  end

  def initialize x:, y:, z:, options: {}
    self.q = Quaternion 0, x, y, z
    @options = options
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

  def midpoint *other
    self.class.new(
      x: (x + other.map(&:x).reduce(&:+)) / (other.size + 1.0),
      y: (y + other.map(&:y).reduce(&:+)) / (other.size + 1.0),
      z: (z + other.map(&:z).reduce(&:+)) / (other.size + 1.0),
    )
  end

  def dist other
    (q + other.q.conjugate).length
  end
end
