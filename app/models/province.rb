class Province < ApplicationRecord
  belongs_to :planet

  def self.from_polygon polygon
    new dump: polygon.dump
  end

  def to_polygon
    Polygon.from_dump dump
  end
end
