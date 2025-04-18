unit
class mat3
    %Using ROW_MAJOR order!
    implement "mat3h.t"
    import "mat4h.t", "../Vector/vec3h.t"

    body procedure _set %(d0, d1, d2, d3, d4, d5, d6, d7, d8 : real)
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

    body procedure setIdentity %()
	_set (1, 0, 0, 0, 1, 0, 0, 0, 1)
    end setIdentity

    body procedure setCopy %(other : ^mat3, mat4)
	if objectclass (other) >= mat3 then
	    _set (mat3h (other).data (0), mat3h (other).data (1), mat3h (other).data (2),
		mat3h (other).data (3), mat3h (other).data (4), mat3h (other).data (5),
		mat3h (other).data (6), mat3h (other).data (7), mat3h (other).data (8))
	elsif objectclass (other) >= mat4h then
	    _set (mat4h (other).data (0), mat4h (other).data (1), mat4h (other).data (2),
		mat4h (other).data (4), mat4h (other).data (5), mat4h (other).data (6),
		mat4h (other).data (8), mat4h (other).data (9), mat4h (other).data (10))
	else
	    put "Error in mat3.t - invalid pointer type given to setCopy"
	    data (0) := mat3 (other).data (0)
	end if
    end setCopy

    body procedure setRotateByAxis %(axis : char, degrees : real)
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

    body procedure multVal %(scalar : real)
	_set (data (0) * scalar, data (1) * scalar, data (2) * scalar,
	    data (3) * scalar, data (4) * scalar, data (5) * scalar,
	    data (6) * scalar, data (7) * scalar, data (8) * scalar)
    end multVal

    body procedure divVal %(scalar : real)
	_set (data (0) / scalar, data (1) / scalar, data (2) / scalar,
	    data (3) / scalar, data (4) / scalar, data (5) / scalar,
	    data (6) / scalar, data (7) / scalar, data (8) / scalar)
    end divVal

    body function getNeg %() : ^mat3
	var temp : ^mat3
	new temp
	temp -> setCopy (self)
	temp -> multVal (-1)
	result temp
    end getNeg

    body function getMultVec %(M : ^vec3h) : ^vec3h
	var temp : ^vec3h
	new temp
	if objectclass (M) >= vec3h then
	    temp -> x := vec3h (M).x * data (0) + vec3h (M).y * data (1) + vec3h (M).z * data (2)
	    temp -> y := vec3h (M).x * data (3) + vec3h (M).y * data (4) + vec3h (M).z * data (5)
	    temp -> z := vec3h (M).x * data (6) + vec3h (M).y * data (7) + vec3h (M).z * data (8)
	else
	    put "Error in mat3.t - invalid pointer type given to getMultVec"
	    temp -> x := vec3h (M).x
	end if
	result temp
    end getMultVec

    body procedure addMat %(M : ^mat3)
	if objectclass (M) >= mat3 then
	    _set (data (0) + mat3 (M).data (0), data (1) + mat3 (M).data (1), data (2) + mat3 (M).data (2),
		data (3) + mat3 (M).data (3), data (4) + mat3 (M).data (4), data (5) + mat3 (M).data (5),
		data (6) + mat3 (M).data (6), data (7) + mat3 (M).data (7), data (8) + mat3 (M).data (8))
	else
	    put "Error in mat3.t - invalid pointer type given to addMat"
	end if
    end addMat

    body procedure subMat %(M : ^mat3)
	if objectclass (M) >= mat3 then
	    _set (data (0) - mat3 (M).data (0), data (1) - mat3 (M).data (1), data (2) - mat3 (M).data (2),
		data (3) - mat3 (M).data (3), data (4) - mat3 (M).data (4), data (5) - mat3 (M).data (5),
		data (6) - mat3 (M).data (6), data (7) - mat3 (M).data (7), data (8) - mat3 (M).data (8))
	else
	    put "Error in mat3.t - invalid pointer type given to subMat"
	end if
    end subMat

    body procedure multMat %(M : ^mat3)
	if objectclass (M) >= mat3 then
	    var temp : ^mat3
	    new temp
	    temp -> data (0) := mat3 (M).data (0) * data (0) + mat3 (M).data (3) * data (1) + mat3 (M).data (6) * data (2)
	    temp -> data (1) := mat3 (M).data (1) * data (0) + mat3 (M).data (4) * data (1) + mat3 (M).data (7) * data (2)
	    temp -> data (2) := mat3 (M).data (2) * data (0) + mat3 (M).data (5) * data (1) + mat3 (M).data (8) * data (2)
	    temp -> data (3) := mat3 (M).data (0) * data (3) + mat3 (M).data (3) * data (4) + mat3 (M).data (6) * data (5)
	    temp -> data (4) := mat3 (M).data (1) * data (3) + mat3 (M).data (4) * data (4) + mat3 (M).data (7) * data (5)
	    temp -> data (5) := mat3 (M).data (2) * data (3) + mat3 (M).data (5) * data (4) + mat3 (M).data (8) * data (5)
	    temp -> data (6) := mat3 (M).data (0) * data (6) + mat3 (M).data (3) * data (7) + mat3 (M).data (6) * data (8)
	    temp -> data (7) := mat3 (M).data (1) * data (6) + mat3 (M).data (4) * data (7) + mat3 (M).data (7) * data (8)
	    temp -> data (8) := mat3 (M).data (2) * data (6) + mat3 (M).data (5) * data (7) + mat3 (M).data (8) * data (8)
	    setCopy (temp)
	    free temp
	else
	    put "Error in mat3.t - invalid pointer type given to multMat"
	end if
    end multMat

    body procedure rotateSingle %(axis : char, degrees : real)
	var rotation : ^mat3
	new rotation
	rotation -> setRotateByAxis (axis, degrees)
	multMat (rotation)
	free rotation
    end rotateSingle

    body procedure rotate %(axis : ^Vector.vec3, degrees : real)
	%Coded as according to c++, but even that one does nothing?
	/*var rotationX : ^mat3
	 new rotationX
	 rotationX -> setRotateByAxis ('x', degrees * axis -> x)
	 var rotationY : ^mat3
	 new rotationY
	 rotationY -> setRotateByAxis ('y', degrees * axis -> y)
	 var rotationZ : ^mat3
	 new rotationZ
	 rotationZ -> setRotateByAxis ('z', degrees * axis -> z)
	 var rotationZY : ^mat3
	 rotationZY := rotationZ -> getMult (rotationY)
	 var rotationZYX : ^mat3
	 rotationZYX := rotationZY -> getMult (rotationX)

	 multMat(rotationZYX) %added this in by guessing... eh?

	 free rotationX
	 free rotationY
	 free rotationZ
	 free rotationZY
	 free rotationZYX
	 */
    end rotate

    body procedure rotateXYZ %(x, y, z : real)
	rotateSingle ('y', y)
	rotateSingle ('x', x)
	rotateSingle ('z', z)
    end rotateXYZ

    body procedure scale %(scaleFactor : ^vec3)
	if objectclass (scaleFactor) >= vec3h then
	    var temp : ^mat3
	    new temp
	    temp -> _set (vec3h (scaleFactor).x, 0.0, 0.0, 0.0, vec3h (scaleFactor).y, 0.0, 0.0, 0.0, vec3h (scaleFactor).z)
	    multMat (temp)
	    free temp
	else
	    put "Error in mat3.t - invalid pointer type given to scale"
	end if
    end scale

    body procedure transpose %()
	var temp : ^mat3
	new temp
	temp -> setCopy (self)
	_set (temp -> data (0), temp -> data (3), temp -> data (6),
	    temp -> data (1), temp -> data (4), temp -> data (7),
	    temp -> data (2), temp -> data (5), temp -> data (8))
	free temp
    end transpose

    body function getColumn %(var colNum : int) : ^vec3
	var temp : ^vec3h
	new temp
	if colNum = 0 then
	    temp -> _set (data (0), data (3), data (6))
	elsif colNum = 1 then
	    temp -> _set (data (1), data (4), data (7))
	elsif colNum = 2 then
	    temp -> _set (data (2), data (5), data (8))
	else
	    temp -> _set (0, 0, 0)
	end if
	result temp
    end getColumn

    body function equals %(M : ^mat3h) : boolean
	if objectclass (M) >= mat3h then
	    result data (0) = mat3h (M).data (0) and data (1) = mat3h (M).data (1) and data (2) = mat3h (M).data (2)
		and data (3) = mat3h (M).data (3) and data (4) = mat3h (M).data (4) and data (5) = mat3h (M).data (5)
		and data (6) = mat3h (M).data (6) and data (7) = mat3h (M).data (7) and data (8) = mat3h (M).data (8)
	else
	    put "Error in mat3.t - invalid pointer type given to equals"
	    result data (0) = mat3h (M).data (0)
	end if
    end equals

    body procedure print %()
	put "[", data (0), ", ", data (1), ", ", data (2), "]"
	put "[", data (3), ", ", data (4), ", ", data (5), "]"
	put "[", data (6), ", ", data (7), ", ", data (8), "]"
    end print
end mat3












