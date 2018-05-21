module Polyhedron::BasicShape
  def isocahedron r: 1
    points = []
    dist = Math::sin(Math::PI/3)*r/2.0
    v = ->{Polyhedron.new(points: [Point.new(r, dist, 0)], faces: [])}
    points << v.call.points[0]
    points << v.call.rotate!(Quaternion(0,0,1,0), TAU/5).points[0]
    points << v.call.rotate!(Quaternion(0,0,1,0), 2*TAU/5).points[0]
    points << v.call.rotate!(Quaternion(0,0,1,0), 3*TAU/5).points[0]
    points << v.call.rotate!(Quaternion(0,0,1,0), 4*TAU/5).points[0]
    v = ->{Polyhedron.new(points: [Point.new(-r, -dist, 0)], faces: [])}
    points << v.call.points[0]
    points << v.call.rotate!(Quaternion(0,0,1,0), TAU/5).points[0]
    points << v.call.rotate!(Quaternion(0,0,1,0), 2*TAU/5).points[0]
    points << v.call.rotate!(Quaternion(0,0,1,0), 3*TAU/5).points[0]
    points << v.call.rotate!(Quaternion(0,0,1,0), 4*TAU/5).points[0]

    points << Point.new(0, r, 0)
    points << Point.new(0, -r, 0)

    polyhedron = Polyhedron.new(
      points: points,
      faces: [
        [0, 8, 1],
        [8, 1, 9],
        [1, 9, 2],
        [9, 2, 5],
        [2, 5, 3],
        [5, 3, 6],
        [3, 6, 4],
        [6, 4, 7],
        [4, 7, 0],
        [7, 0, 8],
        [0, 1, 10],
        [1, 2, 10],
        [2, 3, 10],
        [3, 4, 10],
        [4, 0, 10],
        [8, 9, 11],
        [9, 5, 11],
        [5, 6, 11],
        [6, 7, 11],
        [7, 8, 11],
      ]
    )

    polyhedron.unify!.scale!(r)
  end

end
