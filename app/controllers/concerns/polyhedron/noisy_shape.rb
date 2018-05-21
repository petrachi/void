module Polyhedron::NoisyShape
  def noisy_isocahedron
    polyhedron = Polyhedron.isocahedron

    polyhedron.polygons.each do |polygon|
      polygon.options[:noise] = rand
    end

    polyhedron
  end
end
