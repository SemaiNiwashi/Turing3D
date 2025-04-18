unit
class mat3h
    %Using ROW_MAJOR order!
    implement by "mat3.t"
    export var data, _set, setIdentity, setCopy, setRotateByAxis, multVal,
	divVal, getNeg, getMultVec, addMat, subMat, multMat, rotateSingle,
	rotate, rotateXYZ, scale, transpose, getColumn, equals, print
    var data : array 0 .. 8 of real := init (0, 0, 0, 0, 0, 0, 0, 0, 0)

    deferred procedure _set (d0, d1, d2, d3, d4, d5, d6, d7, d8 : real)
    deferred procedure setIdentity ()
    deferred procedure setCopy (other : ^anyclass) %mat3, mat4
    deferred procedure setRotateByAxis (axis : char, degrees : real)
    deferred procedure multVal (scalar : real)
    deferred procedure divVal (scalar : real)
    deferred function getNeg () : ^mat3h
    deferred function getMultVec (M : ^anyclass) : ^anyclass %vec3, %vec3
    deferred procedure addMat (M : ^anyclass) %mat3, mat4
    deferred procedure subMat (M : ^anyclass) %mat3, mat4
    deferred procedure multMat (M : ^anyclass) %mat3, mat4
    deferred procedure rotateSingle (axis : char, degrees : real)
    deferred procedure rotate (axis : ^anyclass, degrees : real) %vec3
    deferred procedure rotateXYZ (x, y, z : real)
    deferred procedure scale (scaleFactor : ^anyclass) %vec3
    deferred procedure transpose ()
    deferred function getColumn (var colNum : int) : ^anyclass %vec3
    deferred function equals (var M : ^mat3h) : boolean
    deferred procedure print ()
end mat3h











