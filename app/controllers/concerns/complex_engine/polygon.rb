class ComplexEngine::Polygon
  attr_accessor :points

  def initialize *points
    @points = points
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
end
