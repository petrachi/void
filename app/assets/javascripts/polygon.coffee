class window.Polygon
  constructor: (@points, @options) ->
    @path_elt = document.createElementNS("http://www.w3.org/2000/svg", "path")
    if @options['noise']
      @path_elt.setAttribute 'fill', "rgb(#{ Math.floor(@options['noise'] * 255) }, #{ Math.floor(@options['noise'] * 127) }, #{ 255 - Math.floor(@options['noise'] * 255) })"
      @path_elt.setAttribute 'stroke', "rgb(#{ Math.floor(@options['noise'] * 255) }, #{ Math.floor(@options['noise'] * 127) }, #{ 255 - Math.floor(@options['noise'] * 255) })"

    if @options['fill']
      @path_elt.setAttribute 'fill', @options['fill']
      @path_elt.setAttribute 'stroke', @options['fill']

  toSvg: (perspective) ->
    @path_elt.setAttribute 'd', @path(perspective)

  path: (perspective) ->
    path = "M "
    for pt in @points
      do ->
        proj = pt.proj perspective
        path += "#{ proj.x() } #{ -proj.y() } L "

    path = path.substring(0, path.length - 2)
    path += "Z"

  sumZ: ->
    sum = 0
    for point in @points
      do ->
        sum += point.z()
    sum / @points.length
