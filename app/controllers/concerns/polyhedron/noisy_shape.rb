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
    persistance = 0.35
    # plus petit == plus escarpé
    # plus grand == plus smooth

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

    polyhedron.polygons.each do |polygon|
      # polygon.options[:noise] = polygon.points.reduce(0){ |sum, point| sum += point.options[:noise] } / polygon.points.size.to_f

      polygon.options[:noise] = polygon.points.map{|point| point.options[:noise]}.max

      if polygon.options[:noise] >= 0.8
        polygon.options[:fill] = fill(0.9)
      elsif polygon.options[:noise] >= 0.75
        polygon.options[:fill] = fill(0.75)
      elsif polygon.options[:noise] >= 0.7
        polygon.options[:fill] = fill(0.7)
      elsif polygon.options[:noise] >= 0.5
        polygon.options[:fill] = fill(0.5)
      else
        polygon.options[:fill] = fill(0.3)
      end
    end

    polyhedron.points.each do |point|
      # point.options[:noise] **= 2
      # point.scale! (1 + point.options[:noise]*0.3), Quaternion(0,0,0,0)
      if point.options[:noise] >= 0.8
        point.scale! 1.2, Quaternion(0,0,0,0)
      elsif point.options[:noise] >= 0.75
        point.scale! 1.15, Quaternion(0,0,0,0)
      elsif point.options[:noise] >= 0.7
        point.scale! 1.1, Quaternion(0,0,0,0)
      elsif point.options[:noise] >= 0.5
        point.scale! 1.05, Quaternion(0,0,0,0)
      end
    end
  end

  def fill value
    "rgb(#{ (value * 255).to_i }, #{ (value * 127).to_i }, #{ 255 - (value * 255).to_i })"
  end
end
