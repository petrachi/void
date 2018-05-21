class window.Polygon
  constructor: (@points) ->
    @path_elt = document.createElementNS("http://www.w3.org/2000/svg", "path")

  toSvg: (perspective) ->
    @path_elt.setAttribute 'd', @path(perspective)

  path: (perspective) ->
    projs = for pt in @points
      proj = pt.proj perspective
      "#{proj.x()} #{-proj.y()}"

    "M " + projs.join(" L ") + " Z"

  sumZ: ->
    @points.map((point) => point.z()).reduce((a, b) => a + b)
