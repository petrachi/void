class Polyhedron
  extend Polyhedron::BasicShape
  extend Polyhedron::NoisyShape

  attr_accessor :points, :faces, :polygons

  def self.from_polygons polygons
    points = polygons.map(&:points).flatten.uniq
    faces = polygons.map do |polygon|
      polygon.points.map { |point| points.index point }
    end
    new points: points, faces: faces, polygons: polygons
  end

  def initialize points:, faces:, polygons: []
    @points = points
    @faces = faces
    @polygons = faces.each_with_index.map do |face, i|
      Polygon.new points: face.map{ |index| points[index] }, options: polygons[i]&.options || {}
    end
  end

  def to_polyhedron
    self
  end

  def to_js
    params = {
      points: points.map(&:q).map(&:imag),
      faces: faces,
      polygons_options: polygons.map(&:options),
      points_options: points.map(&:options),
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

  def divide method
    self.class.from_polygons polygons.map { |polygon| polygon.divide method }.flatten
  end
end
