class window.Polyhedron
  this.initialize = (params) ->
    new Polyhedron(new Point(pt[0], pt[1], pt[2]) for pt in params['points'], params['faces'])

  constructor: (@points, @faces) ->
    @polygons = for face in @faces
      new Polygon(@points[index] for index in face)

  translate: (q) ->
    point.translate(q) for point in @points
    this

  rotate: (q, phi, origin = new Quaternion(0,0,0,0)) ->
    sin = Math.sin phi/2.0
    c = q.unify().imag()
    h = new Quaternion(Math.cos(phi/2.0), c[0] * sin, c[1] * sin, c[2] * sin)

    point.rotate(h, origin) for point in @points
    this

  scale: (length, origin = new Quaternion(0,0,0,0)) ->
    point.scale(length, origin) for point in @points
    this

  toSvg: (svg_elt, perspective = new Quaternion(0, 0, 0, -Infinity)) ->
    polygons = @polygons.sort (a,b) ->
      b.sumZ() - a.sumZ()

    for polygon in polygons
      polygon.toSvg perspective
      svg_elt.appendChild polygon.path_elt
