class Polygon
  attr_accessor :points

  def self.from_dump dump
    new *dump.split('|').map{ |dump| Point.from_dump dump }
  end

  def initialize *points
    @points = points
  end

  def dump
    points.map(&:dump).join("|")
  end

  def to_svg view, perspective
    view.content_tag :path, nil, d: path(perspective)
  end

  def path perspective
    "M " << points.map do |pt|
      proj = pt.proj perspective
      "#{proj.x} #{-proj.y}"
    end.join(" L ") << " Z"
  end

  def sum_z
    points.map(&:z).reduce(&:+)
  end

  def divide
    if points.size == 3
      midpoints = [
        points[0].midpoint(points[1]),
        points[1].midpoint(points[2]),
        points[2].midpoint(points[0]),
      ]

      [
        self.class.new(points[0], midpoints[0], midpoints[2]),
        self.class.new(points[1], midpoints[0], midpoints[1]),
        self.class.new(points[2], midpoints[1], midpoints[2]),
        self.class.new(midpoints[0], midpoints[1], midpoints[2]),
      ]
    else
      [self.class.new(*points)]
    end
  end
end
