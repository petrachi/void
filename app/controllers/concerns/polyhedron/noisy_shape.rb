module Polyhedron::NoisyShape
  def noisy_isocahedron
    polyhedron = Polyhedron.isocahedron
    octaves = []
    divisions = 3

    divisions.times do
      octaves << polyhedron.points

      polyhedron = polyhedron.divide(:triforce)
      polyhedron.unify!
    end

    base_noise polyhedron
    perlin_noise polyhedron, octaves, divisions

    polyhedron
  end

  def base_noise polyhedron
    polyhedron.points.each do |point|
      point.options[:base_noise] = rand
      point.options[:octave_noise] = []
      point.options[:noise] = 0
    end
  end

  def interpolate x0, x1, alpha
    x0 * (1 - alpha) + alpha * x1
  end

  def smooth_noise polyhedron, octaves, i
    octave = octaves[i]

    points = polyhedron.points.select do |point|
      octave.include? point
    end

    polyhedron.points.each do |point|
      close_points = points.sort_by{ |e| e.dist(point) }[0..4].sort_by{ |e| e.y }

      weighted_noise = close_points.reduce(0) do |sum, e|
        sum += e.options[:base_noise] * e.dist(point)
      end

      weight = close_points.reduce(0) do |sum, e|
        sum += e.dist(point)
      end

      noise = weighted_noise / weight

      point.options[:octave_noise][i] = noise
    end
  end

  def perlin_noise polyhedron, octaves, divisions
    smooth_noises = []
    persistance = 0.5

    divisions.times do |i|
      smooth_noise(polyhedron, octaves, i)
    end

    polyhedron.points.each do |point|
      amplitude = 1.0
      total_amplitude = 0.0

      point.options[:octave_noise].reverse.each do |noise|
        amplitude *= persistance
        total_amplitude += amplitude

        point.options[:noise] += noise * amplitude
      end

      point.options[:noise] /= total_amplitude
    end

    polyhedron.polygons.each_with_index do |polygon, i|
      polygon.options[:noise] = polygon.points.reduce(0){ |sum, point| sum += point.options[:noise] } / polygon.points.size.to_f
    end
  end
end
