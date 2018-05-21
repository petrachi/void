module Hex
  DIVIDE = 2

  def vector r: 1
    ComplexEngine::Polyhedron.new(points: [
        ComplexEngine::Point.new(0, r, 0),
      ],
      faces: []
    )
  end

  def unify polyhedron
    ComplexEngine::Polyhedron.new points: polyhedron.points.map{ |point|
      ComplexEngine::Point.new(point.q.unify.imag)
    },
    faces: polyhedron.faces
  end

  def tetrahedron r: 1
    dist = Math::sin(Math::PI/3)*r/2.0

    points = []
    v = ->{ComplexEngine::Polyhedron.new(points: [ComplexEngine::Point.new(r, -dist, 0)], faces: [])}
    points << v.call.points[0]
    points << v.call.rotate!(Quaternion(0,0,1,0), TAU/3).points[0]
    points << v.call.rotate!(Quaternion(0,0,1,0), 2*TAU/3).points[0]
    points << ComplexEngine::Point.new(0, dist*2.0, 0)

    polyhedron = ComplexEngine::Polyhedron.new points: points,
    faces: [
      [0, 1, 3],
      [1, 2, 3],
      [2, 0, 3],
      [0, 1, 2],
    ]

    unify(polyhedron).scale!(r)
  end

  def octahedron r: 1
    polyhedron = ComplexEngine::Polyhedron.new points: [
      ComplexEngine::Point.new(r,0,0),
      ComplexEngine::Point.new(0,0,r),
      ComplexEngine::Point.new(-r,0,0),
      ComplexEngine::Point.new(0,0,-r),
      ComplexEngine::Point.new(0,r,0),
      ComplexEngine::Point.new(0,-r,0)
    ],
    faces: [
      [0, 1, 4],
      [1, 2, 4],
      [2, 3, 4],
      [3, 0, 4],
      [0, 1, 5],
      [1, 2, 5],
      [2, 3, 5],
      [3, 0, 5],
    ]

    unify(polyhedron).scale!(r)
  end

  def isocahedron r: 1
    points = []
    dist = Math::sin(Math::PI/3)*r/2.0
    v = ->{ComplexEngine::Polyhedron.new(points: [ComplexEngine::Point.new(r, dist, 0)], faces: [])}
    points << v.call.points[0]
    points << v.call.rotate!(Quaternion(0,0,1,0), TAU/5).points[0]
    points << v.call.rotate!(Quaternion(0,0,1,0), 2*TAU/5).points[0]
    points << v.call.rotate!(Quaternion(0,0,1,0), 3*TAU/5).points[0]
    points << v.call.rotate!(Quaternion(0,0,1,0), 4*TAU/5).points[0]
    v = ->{ComplexEngine::Polyhedron.new(points: [ComplexEngine::Point.new(-r, -dist, 0)], faces: [])}
    points << v.call.points[0]
    points << v.call.rotate!(Quaternion(0,0,1,0), TAU/5).points[0]
    points << v.call.rotate!(Quaternion(0,0,1,0), 2*TAU/5).points[0]
    points << v.call.rotate!(Quaternion(0,0,1,0), 3*TAU/5).points[0]
    points << v.call.rotate!(Quaternion(0,0,1,0), 4*TAU/5).points[0]

    points << ComplexEngine::Point.new(0, r, 0)
    points << ComplexEngine::Point.new(0, -r, 0)

    polyhedron = ComplexEngine::Polyhedron.new(
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

    polyhedron = unify(polyhedron).scale!(r)
  end

  def divide_isocahedron isocahedron
    points = isocahedron.points
    faces = []
    isocahedron.faces.each do |face|
      point_index = points.size
      points << midpoint(isocahedron.points[face[0]], isocahedron.points[face[1]])
      points << midpoint(isocahedron.points[face[1]], isocahedron.points[face[2]])
      points << midpoint(isocahedron.points[face[2]], isocahedron.points[face[0]])

      faces << [face[0], point_index, point_index + 2]
      faces << [point_index, face[1], point_index + 1]
      faces << [point_index + 1, face[2], point_index + 2]
      faces << [point_index, point_index + 1, point_index + 2]
    end

    points, faces = rationalize points, faces

    ComplexEngine::Polyhedron.new points: points, faces: faces
  end
  alias :divide_cube_triangle :divide_isocahedron
  alias :divide_octahedron :divide_isocahedron
  alias :divide_tetrahedron :divide_isocahedron

  def isocahedron_divide_x_time r: 1, times: DIVIDE
    polyhedron = isocahedron r: r
    polyhedron = unify(polyhedron).scale!(r)
    times.times{ polyhedron = divide_isocahedron(polyhedron) }
    polyhedron
  end

  def isocahedron_divide_x_time_then_unify r: 1, times: DIVIDE
    polyhedron = isocahedron r: r
    times.times{ polyhedron = divide_isocahedron(polyhedron) }
    unify(polyhedron).scale!(r)
  end

  def isocahedron_divide_and_unify_x_time r: 1, times: DIVIDE
    polyhedron = unify(isocahedron r: r)
    times.times{ polyhedron = unify(divide_isocahedron(polyhedron)) }
    p 'iso'
    p polyhedron.faces.size
    p polyhedron.points.size
    polyhedron.scale!(r)
  end

  def cube r: 1
    polyhedron = ComplexEngine::Polyhedron.new points: [
      ComplexEngine::Point.new(r,r,r),
      ComplexEngine::Point.new(-r,r,r),
      ComplexEngine::Point.new(r,-r,r),
      ComplexEngine::Point.new(-r,-r,r),
      ComplexEngine::Point.new(r,r,-r),
      ComplexEngine::Point.new(-r,r,-r),
      ComplexEngine::Point.new(r,-r,-r),
      ComplexEngine::Point.new(-r,-r,-r),
    ],
    faces: [
      [0, 1, 3, 2],
      [4, 5, 7, 6],
      [0, 1, 5, 4],
      [1, 3, 7, 5],
      [3, 2, 6, 7],
      [2, 0, 4, 6],
    ]

    unify(polyhedron).scale!(r)
  end

  def cube_triangle r: 1
    polyhedron = cube r: r

    points = polyhedron.points
    faces = []
    cube.faces.each do |face|
      point_index = points.size

      m1 = midpoint(polyhedron.points[face[0]], polyhedron.points[face[1]])
      m2 = midpoint(polyhedron.points[face[2]], polyhedron.points[face[3]])
      points << midpoint(m1, m2)

      faces << [face[0], face[1], point_index]
      faces << [face[1], face[2], point_index]
      faces << [face[2], face[3], point_index]
      faces << [face[3], face[0], point_index]
    end

    points, faces = rationalize points, faces

    ComplexEngine::Polyhedron.new points: points, faces: faces
  end

  def midpoint p1, p2
    ComplexEngine::Point.new(
      (p1.x + p2.x) / 2.0,
      (p1.y + p2.y) / 2.0,
      (p1.z + p2.z) / 2.0,
    )
  end

  def rationalize points, faces
    rationalize_points = {}
    points.each_with_index do |point, i|
      rationalize_points[i] = []
      points.each_with_index do |compare_point, j|
        if i != j && compare_point.q == point.q
          rationalize_points[i] << j
        end
      end
    end

    deleted_index = []
    rationalize_points.each do |point_index, to_delete|
      next if to_delete.blank?
      next if deleted_index.include? point_index

      faces.each do |face|
        face.each_with_index do |face_index, i|
          if to_delete.include?(face_index)
            deleted_index << face_index
            face[i] = point_index
          end
        end
      end
    end

    deleted_index.uniq.sort.reverse.each do |index|
      points.delete_at(index)
      faces.each do |face|
        face.each_with_index do |face_index, i|
          if face_index > index
            face[i] -= 1
          end
        end
      end
    end

    [points, faces]
  end

  def divide_cube cube
    points = cube.points
    faces = []
    cube.faces.each do |face|
      point_index = points.size
      points << midpoint(cube.points[face[0]], cube.points[face[1]])
      points << midpoint(cube.points[face[1]], cube.points[face[2]])
      points << midpoint(cube.points[face[2]], cube.points[face[3]])
      points << midpoint(cube.points[face[3]], cube.points[face[0]])
      points << midpoint(points[point_index], points[point_index + 2])

      faces << [face[0], point_index, point_index + 4, point_index + 3]
      faces << [point_index, face[1], point_index + 1, point_index + 4]
      faces << [point_index + 4, point_index + 1, face[2], point_index + 2]
      faces << [point_index + 4, point_index + 2, face[3], point_index + 3]
    end

    points, faces = rationalize points, faces

    ComplexEngine::Polyhedron.new points: points, faces: faces
  end

  def cube_divide_x_time r: 1, times: DIVIDE
    polyhedron = cube r: r
    polyhedron = unify(polyhedron).scale!(r)
    times.times{ polyhedron = divide_cube(polyhedron) }
    polyhedron
  end

  def cube_divide_x_time_then_unify r: 1, times: DIVIDE
    polyhedron = cube r: r
    times.times{ polyhedron = divide_cube(polyhedron) }
    unify(polyhedron).scale!(r)
  end

  def cube_divide_and_unify_x_time r: 1, times: DIVIDE
    polyhedron = unify(cube r: r)
    times.times{ polyhedron = unify(divide_cube(polyhedron)) }
    p 'cube'
    p polyhedron.faces.size
    p polyhedron.points.size
    polyhedron.scale!(r)
  end

  extend self
end
