unit
module contLib
    export var vec3, var vec4, var mat3, var mat4, getRotateVecAxis, getRotateVecXYZ
    class vec3
	export var x, var y, var z, _set, setCopy, scale, add, sub, Length,
	    Normalize, print
	var x : real := 0
	var y : real := 0
	var z : real := 0

	procedure _set (xi, yi, zi : real)
	    x := xi
	    y := yi
	    z := zi
	end _set

	procedure setCopy (other : ^vec3)
	    x := other -> x
	    y := other -> y
	    z := other -> z
	end setCopy

	procedure scale (scalar : real)
	    x *= scalar
	    y *= scalar
	    z *= scalar
	end scale

	procedure add (other : ^vec3)
	    x += other -> x
	    y += other -> y
	    z += other -> z
	end add

	procedure sub (other : ^vec3)
	    x -= other -> x
	    y -= other -> y
	    z -= other -> z
	end sub

	function Length () : real
	    result sqrt (x * x + y * y + z * z)
	end Length

	procedure Normalize ()
	    var _length : real := Length ()
	    if _length not= 0 then
		x /= _length
		y /= _length
		z /= _length
	    end if
	end Normalize

	procedure print ()
	    put "[", x, ", ", y, ", ", z, "]"
	end print
    end vec3

    class vec4
	import vec3
	export var x, var y, var z, var w, _set, setCopy, print
	var x : real := 0
	var y : real := 0
	var z : real := 0
	var w : real := 0

	procedure _set (xi, yi, zi, wi : real)
	    x := xi
	    y := yi
	    z := zi
	    w := wi
	end _set

	procedure setCopy (other : ^anyclass) %vec3, vec4
	    if objectclass (other) >= vec3 then
		x := vec3 (other).x
		y := vec3 (other).y
		z := vec3 (other).z
		w := 1
	    elsif objectclass (other) >= vec4 then
		x := vec4 (other).x
		y := vec4 (other).y
		z := vec4 (other).z
		w := vec4 (other).w
	    end if
	end setCopy

	procedure print ()
	    put "(", x, ", ", y, ", ", z, ", ", w, ")"
	end print
    end vec4

    class mat3
	import vec3
	%Using ROW_MAJOR order!

	export var data, _set, setCopy, setRotateByAxis, multVal, getNeg,
	    getMultVec, transpose, print
	var data : array 0 .. 8 of real := init (0, 0, 0, 0, 0, 0, 0, 0, 0)

	procedure _set (d0, d1, d2, d3, d4, d5, d6, d7, d8 : real)
	    data (0) := d0
	    data (1) := d1
	    data (2) := d2
	    data (3) := d3
	    data (4) := d4
	    data (5) := d5
	    data (6) := d6
	    data (7) := d7
	    data (8) := d8
	end _set

	procedure setCopy (other : ^mat3)
	    data (0) := other -> data (0)
	    data (1) := other -> data (1)
	    data (2) := other -> data (2)
	    data (3) := other -> data (3)
	    data (4) := other -> data (4)
	    data (5) := other -> data (5)
	    data (6) := other -> data (6)
	    data (7) := other -> data (7)
	    data (8) := other -> data (8)
	end setCopy

	procedure setRotateByAxis (axis : char, degrees : real)
	    if axis = 'x' then
		_set (1, 0, 0, 0, cosd (degrees), -sind (degrees), 0, sind (degrees), cosd (degrees))
	    elsif axis = 'y' then
		_set (cosd (degrees), 0, sind (degrees), 0, 1, 0, -sind (degrees), 0, cosd (degrees))
		%_set (cosd (degrees), 0, -sind (degrees), 0, 1, 0, sind (degrees), 0, cosd (degrees))
	    elsif axis = 'z' then
		_set (cosd (degrees), -sind (degrees), 0, sind (degrees), cosd (degrees), 0, 0, 0, 1)
	    else
		put "Error - invalid axis \"", axis, "\""
	    end if
	end setRotateByAxis

	procedure multVal (scalar : real)
	    data (0) *= scalar
	    data (1) *= scalar
	    data (2) *= scalar
	    data (3) *= scalar
	    data (4) *= scalar
	    data (5) *= scalar
	    data (6) *= scalar
	    data (7) *= scalar
	    data (8) *= scalar
	end multVal

	function getNeg () : ^mat3
	    var temp : ^mat3
	    new temp
	    temp -> setCopy (self)
	    temp -> multVal (-1)
	    result temp
	end getNeg

	function getMultVec (M : ^vec3) : ^vec3
	    var temp : ^vec3
	    new temp
	    temp -> x := M -> x * data (0) + M -> y * data (1) + M -> z * data (2)
	    temp -> y := M -> x * data (3) + M -> y * data (4) + M -> z * data (5)
	    temp -> z := M -> x * data (6) + M -> y * data (7) + M -> z * data (8)
	    result temp
	end getMultVec

	procedure transpose ()
	    var temp : ^mat3
	    new temp
	    temp -> setCopy (self)
	    data (0) := temp -> data (0)
	    data (1) := temp -> data (3)
	    data (2) := temp -> data (6)
	    data (3) := temp -> data (1)
	    data (4) := temp -> data (4)
	    data (5) := temp -> data (7)
	    data (6) := temp -> data (2)
	    data (7) := temp -> data (5)
	    data (8) := temp -> data (8)
	    free temp
	end transpose

	procedure print ()
	    put "[", data (0), ", ", data (1), ", ", data (2), "]"
	    put "[", data (3), ", ", data (4), ", ", data (5), "]"
	    put "[", data (6), ", ", data (7), ", ", data (8), "]"
	end print
    end mat3

    class mat4
	import vec3, vec4, mat3
	%Using ROW_MAJOR order!
	export var data, _set, setAll, setCopy, setTranslate, setRotateByAxis,
	    getMultVec, multMat, rotateSingle, rotateXYZ, getPos, getInverse,
	    Frustum, print
	var data : array 0 .. 15 of real := init (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)

	procedure _set (d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15 : real)
	    data (0) := d0
	    data (1) := d1
	    data (2) := d2
	    data (3) := d3
	    data (4) := d4
	    data (5) := d5
	    data (6) := d6
	    data (7) := d7
	    data (8) := d8
	    data (9) := d9
	    data (10) := d10
	    data (11) := d11
	    data (12) := d12
	    data (13) := d13
	    data (14) := d14
	    data (15) := d15
	end _set

	procedure setAll (rotation : ^mat3, position : ^vec3)
	    data (0) := rotation -> data (0)
	    data (1) := rotation -> data (1)
	    data (2) := rotation -> data (2)
	    data (3) := position -> x
	    data (4) := rotation -> data (3)
	    data (5) := rotation -> data (4)
	    data (6) := rotation -> data (5)
	    data (7) := position -> y
	    data (8) := rotation -> data (6)
	    data (9) := rotation -> data (7)
	    data (10) := rotation -> data (8)
	    data (11) := position -> z
	    data (12) := 0
	    data (13) := 0
	    data (14) := 0
	    data (15) := 1
	end setAll

	procedure setCopy (other : ^mat4)
	    data (0) := other -> data (0)
	    data (1) := other -> data (1)
	    data (2) := other -> data (2)
	    data (3) := other -> data (3)
	    data (4) := other -> data (4)
	    data (5) := other -> data (5)
	    data (6) := other -> data (6)
	    data (7) := other -> data (7)
	    data (8) := other -> data (8)
	    data (9) := other -> data (9)
	    data (10) := other -> data (10)
	    data (11) := other -> data (11)
	    data (12) := other -> data (12)
	    data (13) := other -> data (13)
	    data (14) := other -> data (14)
	    data (15) := other -> data (15)
	end setCopy

	procedure setTranslate (other : ^vec3)
	    _set (1, 0, 0, other -> x, 0, 1, 0, other -> y, 0, 0, 1, other -> z, 0, 0, 0, 1)
	end setTranslate

	procedure setRotateByAxis (axis : char, degrees : real)
	    if axis = 'x' then
		_set (1, 0, 0, 0, 0, cosd (degrees), -sind (degrees), 0, 0, sind (degrees), cosd (degrees), 0, 0, 0, 0, 1)
	    elsif axis = 'y' then
		%_set (cos(degrees), 0, sin(degrees), 0, 0, 1, 0, 0, -sin(degrees), 0, cos(degrees), 0, 0, 0, 0, 1)
		_set (cosd (degrees), 0, -sind (degrees), 0, 0, 1, 0, 0, sind (degrees), 0, cosd (degrees), 0, 0, 0, 0, 1)
	    elsif axis = 'z' then
		_set (cosd (degrees), -sind (degrees), 0, 0, sind (degrees), cosd (degrees), 0, 0, 0, 0, 1, 0, 0, 0, 0, 1)
	    else
		put "Error - invalid axis \"", axis, "\""
	    end if
	end setRotateByAxis

	function getMultVec (vector : ^vec4) : ^vec4
	    var temp : ^vec4
	    new temp
	    temp -> x := vector -> x * data (0) + vector -> y * data (1) + vector -> z * data (2) + vector -> w * data (3)
	    temp -> y := vector -> x * data (4) + vector -> y * data (5) + vector -> z * data (6) + vector -> w * data (7)
	    temp -> z := vector -> x * data (8) + vector -> y * data (9) + vector -> z * data (10) + vector -> w * data (11)
	    temp -> w := vector -> x * data (12) + vector -> y * data (13) + vector -> z * data (14) + vector -> w * data (15)
	    result temp
	end getMultVec

	procedure multMat (M : ^mat4)
	    var temp : ^mat4
	    new temp
	    temp -> data (0) := M -> data (0) * data (0) + M -> data (4) * data (1) + M -> data (8) * data (2) + M -> data (12) * data (3)
	    temp -> data (1) := M -> data (1) * data (0) + M -> data (5) * data (1) + M -> data (9) * data (2) + M -> data (13) * data (3)
	    temp -> data (2) := M -> data (2) * data (0) + M -> data (6) * data (1) + M -> data (10) * data (2) + M -> data (14) * data (3)
	    temp -> data (3) := M -> data (3) * data (0) + M -> data (7) * data (1) + M -> data (11) * data (2) + M -> data (15) * data (3)
	    temp -> data (4) := M -> data (0) * data (4) + M -> data (4) * data (5) + M -> data (8) * data (6) + M -> data (12) * data (7)
	    temp -> data (5) := M -> data (1) * data (4) + M -> data (5) * data (5) + M -> data (9) * data (6) + M -> data (13) * data (7)
	    temp -> data (6) := M -> data (2) * data (4) + M -> data (6) * data (5) + M -> data (10) * data (6) + M -> data (14) * data (7)
	    temp -> data (7) := M -> data (3) * data (4) + M -> data (7) * data (5) + M -> data (11) * data (6) + M -> data (15) * data (7)
	    temp -> data (8) := M -> data (0) * data (8) + M -> data (4) * data (9) + M -> data (8) * data (10) + M -> data (12) * data (11)
	    temp -> data (9) := M -> data (1) * data (8) + M -> data (5) * data (9) + M -> data (9) * data (10) + M -> data (13) * data (11)
	    temp -> data (10) := M -> data (2) * data (8) + M -> data (6) * data (9) + M -> data (10) * data (10) + M -> data (14) * data (11)
	    temp -> data (11) := M -> data (3) * data (8) + M -> data (7) * data (9) + M -> data (11) * data (10) + M -> data (15) * data (11)
	    temp -> data (12) := M -> data (0) * data (12) + M -> data (4) * data (13) + M -> data (8) * data (14) + M -> data (12) * data (15)
	    temp -> data (13) := M -> data (1) * data (12) + M -> data (5) * data (13) + M -> data (9) * data (14) + M -> data (13) * data (15)
	    temp -> data (14) := M -> data (2) * data (12) + M -> data (6) * data (13) + M -> data (10) * data (14) + M -> data (14) * data (15)
	    temp -> data (15) := M -> data (3) * data (12) + M -> data (7) * data (13) + M -> data (11) * data (14) + M -> data (15) * data (15)
	    setCopy (temp)
	    free temp
	end multMat

	procedure rotateSingle (axis : char, degrees : real)
	    var rotation : ^mat4
	    new rotation
	    rotation -> setRotateByAxis (axis, degrees)
	    multMat (rotation)
	    free rotation
	end rotateSingle

	procedure rotateXYZ (x, y, z : real) %yxz or zyx? (don't forget BOTH places!)            
	    rotateSingle ('y', y)
	    rotateSingle ('x', x)
	    rotateSingle ('z', z)
	end rotateXYZ

	function getPos () : ^vec3
	    var temp : ^vec3
	    new temp
	    temp -> _set (data (3), data (7), data (11))
	    result temp
	end getPos
	
	function getInverse () : ^mat4
	    %transpose the rotation and make it negative, multiply the old
	    %position by this vec3, then put both together.
	    var tempRot : ^mat3
	    new tempRot
	    %Set tempRot to copy of self
	    tempRot -> _set (data (0), data (1), data (2), data (4), data (5), data (6), data (8), data (9), data (10))
	    var tempPosA : ^vec3
	    tempPosA := getPos ()
	    tempRot -> transpose ()
	    var negTempRot : ^mat3
	    negTempRot := tempRot -> getNeg ()
	    var tempPos : ^vec3
	    tempPos := negTempRot -> getMultVec (tempPosA)
	    free tempPosA
	    free negTempRot
	    var final : ^mat4
	    new final
	    final -> setAll (tempRot, tempPos)
	    free tempRot
	    free tempPos
	    result final
	end getInverse

	procedure Frustum (fovyDegrees, aspect, near, far : real)
	    var h : real := 1 / tand (fovyDegrees / 2)
	    _set (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
	    data (0) := h / aspect
	    data (5) := h
	    data (10) := (far + near) / (near - far)
	    data (11) := (2 * near * far) / (near - far)
	    data (14) := -1
	end Frustum

	procedure print ()
	    put "[", data (0), ", ", data (1), ", ", data (2), ", ", data (3), "]"
	    put "[", data (4), ", ", data (5), ", ", data (6), ", ", data (7), "]"
	    put "[", data (8), ", ", data (9), ", ", data (10), ", ", data (11), "]"
	    put "[", data (12), ", ", data (13), ", ", data (14), ", ", data (15), "]"
	end print
    end mat4

    %Free-standing functions that couldn't work without header files so
    %that vec3 could know what mat3 is and mat3 could know what vec3 is
     
    function getRotateVecAxis (vector : ^vec3, axis : char, degrees : real) : ^vec3
	var rotation_mat : ^mat3
	new rotation_mat
	rotation_mat -> setRotateByAxis (axis, degrees)
	var temp : ^vec3
	temp := rotation_mat -> getMultVec (vector)
	free rotation_mat
	result temp
    end getRotateVecAxis

    function getRotateVecXYZ (vector : ^vec3, rotx, roty, rotz : real) : ^vec3
	var temp : ^vec3
	temp := getRotateVecAxis (vector, 'y', roty)     %yxz or zyx?
	var temp2 : ^vec3
	temp2 := getRotateVecAxis (temp, 'x', rotx)
	free temp
	temp := getRotateVecAxis (temp2, 'z', rotz)
	free temp2
	result temp
    end getRotateVecXYZ
end contLib
