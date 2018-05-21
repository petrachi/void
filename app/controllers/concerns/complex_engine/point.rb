class ComplexEngine::Point
  attr_accessor :q

  def initialize *coords
    self.q = Quaternion 0, *coords
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

  def rotate_alt! rotation_matrix, origin
    translate! origin.conjugate

    result_matrix = rotation_matrix * Matrix[[x], [y], [z]]
    x = result_matrix.element(0, 0)
    y = result_matrix.element(1, 0)
    z = result_matrix.element(2, 0)

    self.q = Quaternion.new(0, x, y, z) + origin
  end

  def scale! length, origin
    self.q = (origin.conjugate + q) * length + origin
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
end
