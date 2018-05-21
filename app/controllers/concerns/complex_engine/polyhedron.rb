class ComplexEngine::Polyhedron
  attr_accessor :points, :faces, :polygons

  def initialize points:, faces:
    @points = points
    @faces = faces
    @polygons = faces.map do |face|
      ComplexEngine::Polygon.new *face.map{ |index| points[index] }
    end
  end

  def to_svg view, perspective: Quaternion(0, 0, 0, -Float::INFINITY)
    polygons.sort_by(&:sum_z).map{ |polygon| polygon.to_svg(view, perspective) }.reduce(&:concat)
  end

  def to_js
    params = {
      points: points.map(&:q).map(&:imag),
      faces: faces
    }.to_json
    "Polyhedron.initialize(#{params})".html_safe
  end

  def translate! q
    points.each{ |pt| pt.translate! q }
    self
  end

  def rotate! q, phi, origin: Quaternion(0, 0, 0, 0)
    sin = Math::sin(phi/2.0)
    h = Quaternion(
      Math.cos(phi/2.0),
      *q.unify.imag.map{ |c| c * sin }
    )

    points.each{ |pt| pt.rotate! h, origin }
    self
  end

  def rotate_alt! q, phi
    sin = Math.sin phi / 2
    cos = Math.cos phi / 2

    q0 = cos
    q1 = q.unify.imag[0] * sin
    q2 = q.unify.imag[1] * sin
    q3 = q.unify.imag[2] * sin

    rotation_matrix = Matrix[
      [q0**2 + q1**2 - q2**2 - q3**2, 2*(q1*q2 - q0*q3), 2*(q1*q3 + q0*q2)],
      [2*(q2*q1 + q0*q3), q0**2 - q1**2 + q2**2 - q3**2, 2*(q2*q3 - q0*q1)],
      [2*(q3*q1 - q0*q2), 2*(q3*q2 + q0*q1), q0**2 - q1**2 - q2**2 + q3**2],
    ]

    points.each{ |pt| pt.rotate_alt! rotation_matrix }
    self
  end

  def scale! length, origin: Quaternion(0, 0, 0, 0)
    points.each{ |pt| pt.scale! length, origin }
    self
  end
end
