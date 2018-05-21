class Polyhedron
  extend Polyhedron::BasicShape

  attr_accessor :points, :faces, :polygons

  def self.from_polygons polygons
    points = polygons.map(&:points).flatten.uniq
    faces = polygons.map do |polygon|
      polygon.points.map { |point| points.index point }
    end
    new points: points, faces: faces
  end

  def initialize points:, faces:
    @points = points
    @faces = faces
    @polygons = faces.map do |face|
      Polygon.new *face.map{ |index| points[index] }
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

  def scale! length, origin: Quaternion(0, 0, 0, 0)
    points.each{ |pt| pt.scale! length, origin }
    self
  end

  def unify! origin: Quaternion(0, 0, 0, 0)
    points.each{ |pt| pt.unify! origin }
    self
  end

  def divide
    self.class.from_polygons polygons.map(&:divide).flatten
  end
end
