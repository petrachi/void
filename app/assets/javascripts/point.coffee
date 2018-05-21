class window.Point
  constructor: (x, y, z, @options) ->
    @q = new Quaternion(0, x, y, z)

  eql: (other) ->
    @x == other.x && @y == other.y && @z == other.z

  x: ->
    @q.imag()[0]

  y: ->
    @q.imag()[1]

  z: ->
    @q.imag()[2]

  translate: (other) ->
    @q = @q.add other

  rotate: (h, origin) ->
    @q = h.times(@q.add(origin.conj())).times(h.inverse()).add(origin)

  scale: (length, origin) ->
    @q = origin.conj().add(@q).times(length).add(origin)

  proj: (q) ->
    t = -@z() / (@z() - q.imag()[2])
    nx = @x() + ((@x() - q.imag()[0]) * t)
    ny = @y() + ((@y() - q.imag()[1]) * t)

    new Point(nx, ny, 0)
