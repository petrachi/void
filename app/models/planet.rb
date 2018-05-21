class Planet < ApplicationRecord
  has_many :provinces

  def self.from_polyhedron polyhedron
    new provinces: polyhedron.polygons.map { |polygon| Province.from_polygon polygon }
  end

  def to_polyhedron
    Polyhedron.from_polygons provinces.map(&:to_polygon)
  end
end
