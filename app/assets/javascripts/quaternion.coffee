class window.Quaternion
  constructor: (@a, @b, @c, @d) ->

  real: ->
    @a

  imag: ->
    [@b, @c, @d]

  length: ->
    Math.sqrt @a**2 + @b**2 + @c**2 + @d**2

  conj: ->
    new Quaternion(@a, -@b, -@c, -@d)

  inverse: ->
    @conj().div @length()**2

  unify: ->
    @div @length()

  add: (other) ->
    new Quaternion( @a+other.a, @b+other.b, @c+other.c, @d+other.d )

  sub: (other) ->
    new Quaternion( @a-other.a, @b-other.b, @c-other.c, @d-other.d )

  times: (other) ->
    if other instanceof Quaternion
      new Quaternion(
        @a*other.a - @b*other.b - @c*other.c - @d*other.d,
        @a*other.b + @b*other.a + @c*other.d - @d*other.c,
        @a*other.c - @b*other.d + @c*other.a + @d*other.b,
        @a*other.d + @b*other.c - @c*other.b + @d*other.a
      )
    else
      new Quaternion( @a*other, @b*other, @c*other, @d*other )

  div: (other) ->
    if other instanceof Quaternion
      this.times other.inverse()
    else
      this.times 1/other
