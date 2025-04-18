unit
class vec3ih
    implement by "vec3i.t"
    export var x, var y, var z, _set, setCopy, getCopy, addVal, subVal, scale,
	reduce, getNeg, add, sub, mult, _div, asVec2i, asVec2, asVec3, asVec4,
	equals, Length, LengthSquared, print
    var x : int := 0
    var y : int := 0
    var z : int := 0

    deferred procedure _set (xi, yi, zi : int)
    deferred procedure setCopy (other : ^anyclass) %vec2i, vec2, vec3, vec3i, vec4
    deferred function getCopy () : ^vec3ih
    deferred procedure addVal (other : int)
    deferred procedure subVal (other : int)
    deferred procedure scale (scalar : real)
    deferred procedure reduce (scalar : real)
    deferred function getNeg () : ^vec3ih
    deferred procedure add (other : ^anyclass) %vec2i, vec2, vec3, vec3i, vec4
    deferred procedure sub (other : ^anyclass) %vec2i, vec2, vec3, vec3i, vec4
    deferred procedure mult (other : ^anyclass) %vec2i, vec2, vec3, vec3i, vec4
    deferred procedure _div (other : ^anyclass) %vec2i, vec2, vec3, vec3i, vec4
    deferred function asVec2i () : ^anyclass %vec2i
    deferred function asVec2 () : ^anyclass %vec2
    deferred function asVec3 () : ^anyclass %vec3
    deferred function asVec4 () : ^anyclass %vec4
    deferred function equals (other : ^anyclass) : boolean %vec2i, vec2, vec3, vec3i, vec4
    deferred function Length () : real
    deferred function LengthSquared () : real
    deferred procedure print ()
end vec3ih









