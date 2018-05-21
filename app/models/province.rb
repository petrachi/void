class Province < ApplicationRecord
  belongs_to :planet

  def self.from_polygon polygon
    new blob: polygon.to_json
  end

  def to_polygon
    Polygon.from_json blob
  end
end
