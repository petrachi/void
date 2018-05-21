class VoidController < ApplicationController
  def index
    width = 600
    height = 300

    noise = Array.new(height, Array.new(width, nil))
    noise = noise.map{ |row| row.map{ rand }}


    @grid = noise
    @grid = smooth_noise(noise, 4)
    @grid = perlin_noise(noise, 8)
  end

  def perlin_noise base_noise, nb_octave
    height = base_noise.size
    width = base_noise.first.size

    perlin_noise = Array.new(height, Array.new(width, 0))
    smooth_noises = []

    persistance = 0.5

    nb_octave.times do |i|
      smooth_noises << smooth_noise(base_noise, i)
    end

    amplitude = 1.0
    total_amplitude = 0.0

    (nb_octave - 1).downto(0) do |octave|
      amplitude *= persistance
      total_amplitude += amplitude

      perlin_noise = perlin_noise.each_with_index.map do |row, i|
        row.each_with_index.map do |value, j|
          value + smooth_noises[octave][i][j] * amplitude
        end
      end
    end

    perlin_noise.each_with_index.map do |row, i|
      row.each_with_index.map do |value, j|
        value / total_amplitude
      end
    end


  end

  def smooth_noise base_noise, octave
    height = base_noise.size
    width = base_noise.first.size

    smooth_noise = Array.new(height, Array.new(width, nil))

    period = 2 ** octave
    frequency = 1.0 / period

    smooth_noise.each_with_index.map do |row, i|
      i0 = (i / period).to_i * period
      i1 = (i0 + period) % (height - 1)
      horizontal_blend = (i - i0) * frequency

      row.each_with_index.map do |value, j|
        j0 = (j / period).to_i * period
        j1 = (j0 + period) % (width - 1)
        vertical_blend = (j - j0) * frequency

        top = interpolate(
          base_noise[i0][j0],
          base_noise[i1][j0],
          horizontal_blend,
        )

        bottom = interpolate(
          base_noise[i0][j1],
          base_noise[i1][j1],
          horizontal_blend,
        )

        interpolate(top, bottom, vertical_blend)
      end
    end
  end

  def interpolate x0, x1, alpha
    x0 * (1 - alpha) + alpha * x1
  end
end
