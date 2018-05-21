class Polygon
  attr_accessor :points, :options

  def self.from_json json
    attributes = JSON.parse(json).symbolize_keys
    attributes[:points] = attributes[:points].map{ |point_attributes| Point.from_attributes point_attributes }
    new **attributes
  end

  def initialize points:, options: {}
    @points = points
    @options = options
  end

  def sum_z
    points.map(&:z).reduce(&:+)
  end

  def divide method
    case method
    when :triforce
      midpoints = [
        points[0].midpoint(points[1]),
        points[1].midpoint(points[2]),
        points[2].midpoint(points[0]),
      ]

      [
        self.class.new(points: [points[0], midpoints[0], midpoints[2]]),
        self.class.new(points: [points[1], midpoints[0], midpoints[1]]),
        self.class.new(points: [points[2], midpoints[1], midpoints[2]]),
        self.class.new(points: [midpoints[0], midpoints[1], midpoints[2]]),
      ]
    else
      [self.class.new(points: points)]
    end
  end
end
