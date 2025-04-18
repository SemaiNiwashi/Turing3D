unit
class vec4h
    implement by "vec4.t"
    export var x, var y, var z, var w, _set, setCopy, getCopy, addVal, subVal,
	scale, reduce, getNeg, add, sub, mult, _div, asVec2i, asVec2, asVec3,
	asVec3i, equals, Length, LengthSquared, Normalize, getNormalize,
	getDot, print
    var x : real := 0
    var y : real := 0
    var z : real := 0
    var w : real := 0

    deferred procedure _set (xi, yi, zi, wi : real)
    deferred procedure setCopy (other : ^anyclass) %vec2i, vec2, vec3, vec3i, vec4
    deferred function getCopy () : ^vec4h
    deferred procedure addVal (other : real)
    deferred procedure subVal (other : real)
    deferred procedure scale (scalar : real)
    deferred procedure reduce (scalar : real)
    deferred function getNeg () : ^vec4h
    deferred procedure add (other : ^anyclass) %vec2i, vec2, vec3, vec3i, vec4
    deferred procedure sub (other : ^anyclass) %vec2i, vec2, vec3, vec3i, vec4
    deferred procedure mult (other : ^anyclass) %vec2i, vec2, vec3, vec3i, vec4
    deferred procedure _div (other : ^anyclass) %vec2i, vec2, vec3, vec3i, vec4
    deferred function asVec2i () : ^anyclass %vec2i
    deferred function asVec2 () : ^anyclass %vec2
    deferred function asVec3 () : ^anyclass %vec3
    deferred function asVec3i () : ^anyclass %vec3i
    deferred function equals (other : ^anyclass) : boolean %vec2i, vec2, vec3, vec3i, vec4
    deferred function Length () : real
    deferred function LengthSquared () : real
    deferred procedure Normalize ()
    deferred function getNormalize () : ^vec4h
    deferred function getDot (other : ^vec4h) : real
    deferred procedure print ()
end vec4h









