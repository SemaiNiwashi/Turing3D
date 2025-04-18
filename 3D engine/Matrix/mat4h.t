unit
class mat4h
    %Using ROW_MAJOR order!
    implement by "mat4.t"
    export var data, _set, setIdentity, setAll, setCopy, setTranslate, setPosAndRot, setScalar,
	setRotateByAxis, multVal, divVal, getNeg, getMultVec, addMat, subMat,
	multMat, rotateSingle, rotate, rotateXYZ, Translate, scale, getScale,
	transpose, getTranspose, getPos, setPos, getForward, getUp, getInverse,
	equals, Frustum, Ortho, print
    var data : array 0 .. 15 of real := init (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)

    deferred procedure _set (d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15 : real)
    deferred procedure setIdentity ()
    deferred procedure setAll (rotation : ^anyclass, position : ^anyclass) %mat3, vec3
    deferred procedure setCopy (other : ^anyclass) %mat3, mat4
    deferred procedure setTranslate (other : ^anyclass) %vec3
    deferred procedure setPosAndRot (posIn : ^anyclass, x, y, z : real) %vec3
    deferred procedure setScalar (other : ^anyclass) %vec3
    deferred procedure setRotateByAxis (axis : char, degrees : real)
    deferred procedure multVal (scalar : real)
    deferred procedure divVal (scalar : real)
    deferred function getNeg () : ^mat4h
    deferred function getMultVec (M : ^anyclass) : ^anyclass %vec4
    deferred procedure addMat (M : ^anyclass) %mat3, mat4
    deferred procedure subMat (M : ^anyclass) %mat3, mat4
    deferred procedure multMat (M : ^anyclass) %mat3, mat4
    deferred procedure rotateSingle (axis : char, degrees : real)
    deferred procedure rotate (axis : ^anyclass, degrees : real) %vec3
    deferred procedure rotateXYZ (x, y, z : real)
    deferred procedure Translate (translation : ^anyclass) %vec3
    deferred procedure scale (scaleFactor : ^anyclass) %vec3
    deferred function getScale (scaleFactor : ^anyclass) : ^mat4h %vec3
    deferred procedure transpose ()
    deferred function getTranspose () : ^mat4h
    deferred function getPos () : ^anyclass %vec3
    deferred procedure setPos (newPos : ^anyclass) %vec3
    deferred function getForward () : ^anyclass %vec3
    deferred function getUp () : ^anyclass %vec3
    deferred function getInverse () : ^mat4h
    deferred function equals (M : ^mat4h) : boolean
    deferred procedure Frustum (fovyDegrees, aspect, near, far : real)
    deferred procedure Ortho (top, bottom, left, right, near, far : real)
    deferred procedure print ()
end mat4h











