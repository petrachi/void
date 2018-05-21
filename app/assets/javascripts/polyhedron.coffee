class window.Polyhedron
  this.initialize = (params) ->
    new Polyhedron(new Point(pt[0], pt[1], pt[2], params['points_options'][i]) for pt, i in params['points'], params['faces'], params['polygons_options'])

  constructor: (@points, @faces, polygons) ->
    @polygons = for face, i in @faces
      new Polygon(@points[index] for index in face, polygons[i])

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

    t = + new Date()
    polygons = @polygons.sort (a,b) ->
      b.sumZ() - a.sumZ()
    console.log("sort " + (+ new Date() - t))

    t = + new Date()
    for polygon in polygons
      polygon.toSvg perspective
      svg_elt.appendChild polygon.path_elt
    console.log("draw " + (+ new Date() - t))
