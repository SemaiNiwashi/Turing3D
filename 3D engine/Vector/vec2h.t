unit
class vec2h
    implement by "vec2.t"
    export var x, var y, _set, setCopy, getCopy, addVal, subVal, scale, reduce,
	getNeg, add, sub, mult, _div, asVec2i, asVec3, asVec3i, asVec4, equals,
	Length, LengthSquared, Normalize, getDirection, getDot, print
    var x : real := 0
    var y : real := 0

    deferred procedure _set (xi, yi : real)
    deferred procedure setCopy (other : ^anyclass) %vec2i, vec2, vec3, vec3i, vec4
    deferred function getCopy () : ^vec2h
    deferred procedure addVal (other : real)
    deferred procedure subVal (other : real)
    deferred procedure scale (scalar : real)
    deferred procedure reduce (scalar : real)
    deferred function getNeg () : ^vec2h
    deferred procedure add (other : ^anyclass) %vec2i, vec2, vec3, vec3i, vec4
    deferred procedure sub (other : ^anyclass) %vec2i, vec2, vec3, vec3i, vec4
    deferred procedure mult (other : ^anyclass) %vec2i, vec2, vec3, vec3i, vec4
    deferred procedure _div (other : ^anyclass) %vec2i, vec2, vec3, vec3i, vec4
    deferred function asVec2i () : ^anyclass %vec2i
    deferred function asVec3 () : ^anyclass %vec3
    deferred function asVec3i () : ^anyclass %vec3i
    deferred function asVec4 () : ^anyclass %vec4
    deferred function equals (other : ^anyclass) : boolean %vec2i, vec2, vec3, vec3i, vec4
    deferred function Length () : real
    deferred function LengthSquared () : real
    deferred procedure Normalize ()
    deferred function getDirection () : ^vec2h
    deferred function getDot (other : ^vec2h) : real
    deferred procedure print ()
end vec2h









