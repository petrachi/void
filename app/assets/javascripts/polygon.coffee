class window.Polygon
  constructor: (@points, @options) ->
    @path_elt = document.createElementNS("http://www.w3.org/2000/svg", "path")
    if @options['noise']
      # @path_elt.setAttribute 'fill', "rgb(#{ Math.floor(@options['noise'] * 255) }, #{ Math.floor(@options['noise'] * 255) }, #{ Math.floor(@options['noise'] * 255) })"
      @path_elt.setAttribute 'fill', "rgb(#{ Math.floor(@options['noise'] * 255) }, #{ Math.floor(@options['noise'] * 127) }, #{ 255 - Math.floor(@options['noise'] * 255) })"
      @path_elt.setAttribute 'stroke', "rgb(#{ Math.floor(@options['noise'] * 255) }, #{ Math.floor(@options['noise'] * 127) }, #{ 255 - Math.floor(@options['noise'] * 255) })"

  toSvg: (perspective) ->
    @path_elt.setAttribute 'd', @path(perspective)

  path: (perspective) ->
    projs = for pt in @points
      proj = pt.proj perspective
      "#{proj.x()} #{-proj.y()}"

    "M " + projs.join(" L ") + " Z"

  sumZ: ->
    @points.map((point) => point.z()).reduce((a, b) => a + b)
