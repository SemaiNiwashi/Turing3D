unit
class vec3h
    implement by "vec3.t"
    export var x, var y, var z, _set, setCopy, getCopy, setXY, SetAnglesFromVector,
	SetAnglesFromOtherVector, GetAnglesFromVector, addVal, subVal, scale,
	reduce, getNeg, add, sub, mult, _div, asVec2i, asVec2, asVec3i, asVec4,
	equals, Length, LengthSquared, Normalize, getNormalize, getDot, getCross,
	rotateAxis, getRotateAxis, rotate, getRotate, rotateXYZ, getRotateXYZ,
	rotateAxisVecXYZ, getRotateAxisVecXYZ, rotateAxisVec, getRotateAxisVec, print
    var x : real := 0
    var y : real := 0
    var z : real := 0

    deferred procedure _set (xi, yi, zi : real)
    deferred procedure setCopy (other : ^anyclass) %vec2i, vec2, vec3, vec3i, vec4
    deferred function getCopy () : ^vec3h
    deferred procedure setXY (other : ^anyclass) %vec2i, vec2, vec3, vec3i, vec4
    deferred procedure SetAnglesFromVector ()
    deferred procedure SetAnglesFromOtherVector (other : ^vec3h)
    deferred function GetAnglesFromVector () : ^vec3h
    deferred procedure addVal (other : real)
    deferred procedure subVal (other : real)
    deferred procedure scale (scalar : real)
    deferred procedure reduce (scalar : real)
    deferred function getNeg () : ^vec3h
    deferred procedure add (other : ^anyclass) %vec2i, vec2, vec3, vec3i, vec4
    deferred procedure sub (other : ^anyclass) %vec2i, vec2, vec3, vec3i, vec4
    deferred procedure mult (other : ^anyclass) %vec2i, vec2, vec3, vec3i, vec4, mat3, mat4
    deferred procedure _div (other : ^anyclass) %vec2i, vec2, vec3, vec3i, vec4
    deferred function asVec2i () : ^anyclass %vec2i
    deferred function asVec2 () : ^anyclass %vec2
    deferred function asVec3i () : ^anyclass %vec3i
    deferred function asVec4 () : ^anyclass %vec4
    deferred function equals (other : ^anyclass) : boolean %vec2i, vec2, vec3, vec3i, vec4
    deferred function Length () : real
    deferred function LengthSquared () : real
    deferred procedure Normalize ()
    deferred function getNormalize () : ^vec3h
    deferred function getDot (other : ^vec3h) : real
    deferred function getCross (other : ^vec3h) : ^vec3h
    deferred procedure rotateAxis (axis : char, degrees : real)
    deferred function getRotateAxis (axis : char, degrees : real) : ^vec3h
    deferred procedure rotateXYZ (rotx, roty, rotz : real)
    deferred function getRotateXYZ (rotx, roty, rotz : real) : ^vec3h
    deferred procedure rotate (rot : ^vec3h)
    deferred function getRotate (rot : ^vec3h) : ^vec3h
    deferred procedure rotateAxisVecXYZ (axisX, axisY, axisZ : real, degrees : real)
    deferred function getRotateAxisVecXYZ (axisX, axisY, axisZ : real, degrees : real) : ^vec3h
    deferred procedure rotateAxisVec (axis : ^vec3h, degrees : real)
    deferred function getRotateAxisVec (axis : ^vec3h, degrees : real) : ^vec3h
    deferred procedure print ()
end vec3h








