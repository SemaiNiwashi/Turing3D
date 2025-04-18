unit
class mat4
    %Using ROW_MAJOR order!
    implement "mat4h.t"
    import "mat3h.t", "../Vector/vec3h.t", "../Vector/vec4h.t"

    body procedure _set %(d0, d1, d2, d3, d4, d5, d6, d7, d8, ... : real)
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

    body procedure setIdentity %()
	_set (1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1)
    end setIdentity

    body procedure setAll %(rotation : ^mat3, position : ^vec3)
	if objectclass (rotation) >= mat3h and objectclass (position) >= vec3h then
	    _set (mat3h (rotation).data (0), mat3h (rotation).data (1),
		mat3h (rotation).data (2), vec3h (position).x,
		mat3h (rotation).data (3), mat3h (rotation).data (4),
		mat3h (rotation).data (5), vec3h (position).y,
		mat3h (rotation).data (6), mat3h (rotation).data (7),
		mat3h (rotation).data (8), vec3h (position).z,
		0, 0, 0, 1)
	else
	    put "Error in mat4.t - invalid pointer type given to setAll"
	    data (0) := mat3h (rotation).data (0)
	end if
    end setAll

    body procedure setCopy %(other : ^mat3, mat4)
	if objectclass (other) >= mat3h then
	    put "Warning - this function (mat4.setCopy(mat3)) is slightly guesswork."
	    _set (mat3h (other).data (0), mat3h (other).data (1), mat3h (other).data (2), 0,
		mat3h (other).data (3), mat3h (other).data (4), mat3h (other).data (5), 0,
		mat3h (other).data (6), mat3h (other).data (7), mat3h (other).data (8), 0,
		0, 0, 0, 1)
	elsif objectclass (other) >= mat4 then
	    _set (mat4 (other).data (0), mat4 (other).data (1), mat4 (other).data (2), mat4 (other).data (3),
		mat4 (other).data (4), mat4 (other).data (5), mat4 (other).data (6), mat4 (other).data (7),
		mat4 (other).data (8), mat4 (other).data (9), mat4 (other).data (10), mat4 (other).data (11),
		mat4 (other).data (12), mat4 (other).data (13), mat4 (other).data (14), mat4 (other).data (15))
	else
	    put "Error in mat4.t - invalid pointer type given to setCopy"
	    data (0) := mat4 (other).data (0)
	end if
    end setCopy

    body procedure setTranslate %(other : ^vec3)
	if objectclass (other) >= vec3h then
	    _set (1, 0, 0, vec3h (other).x, 0, 1, 0, vec3h (other).y, 0, 0, 1, vec3h (other).z, 0, 0, 0, 1)
	else
	    put "Error in mat4.t - invalid pointer type given to setTranslate"
	    _set (1, 0, 0, vec3h (other).x, 0, 1, 0, vec3h (other).y, 0, 0, 1, vec3h (other).z, 0, 0, 0, 1)
	end if
    end setTranslate

    body procedure setScalar %(other : ^vec3)
	if objectclass (other) >= vec3h then
	    _set (vec3h (other).x, 0, 0, 0, 0, vec3h (other).y, 0, 0, 0, 0, vec3h (other).z, 0, 0, 0, 0, 1)
	else
	    put "Error in mat4.t - invalid pointer type given to setScalar"
	    _set (vec3h (other).x, 0, 0, 0, 0, vec3h (other).y, 0, 0, 0, 0, vec3h (other).z, 0, 0, 0, 0, 1)
	end if
    end setScalar

    %This function is the mathimatically simplified version of doing three
    %separate rotation matrix multiplications, and is thus much faster.
    body procedure setPosAndRot %(posIn : ^vec3, x, y, z : real)
	if objectclass (posIn) >= vec3h then
	    _set (cosd (z) * cosd (y) + sind (z) * sind (x) * -sind (y),
		- sind (z) * cosd (y) + cosd (z) * sind (x) * -sind (y),
		cosd (x) * -sind (y), vec3h (posIn).x, sind (z) * cosd (x),
		cosd (z) * cosd (x), -sind (x), vec3h (posIn).y,
		cosd (z) * sind (y) + sind (z) * sind (x) * cosd (y),
		- sind (z) * sind (y) + cosd (z) * sind (x) * cosd (y),
		cosd (x) * cosd (y), vec3h (posIn).z, 0, 0, 0, 1)
	else
	    put "Error in mat4.t - invalid pointer type given to setPosAndRot"
	end if
    end setPosAndRot

    body procedure setRotateByAxis %(axis : char, degrees : real)
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

    body procedure multVal %(scalar : real)
	_set (data (0) * scalar, data (1) * scalar, data (2) * scalar, data (3) * scalar,
	    data (4) * scalar, data (5) * scalar, data (6) * scalar, data (7) * scalar,
	    data (8) * scalar, data (9) * scalar, data (10) * scalar, data (11) * scalar,
	    data (12) * scalar, data (13) * scalar, data (14) * scalar, data (15) * scalar)
    end multVal

    body procedure divVal %(scalar : real)
	_set (data (0) / scalar, data (1) / scalar, data (2) / scalar, data (3) / scalar,
	    data (4) / scalar, data (5) / scalar, data (6) / scalar, data (7) / scalar,
	    data (8) / scalar, data (9) / scalar, data (10) / scalar, data (11) / scalar,
	    data (12) / scalar, data (13) / scalar, data (14) / scalar, data (15) / scalar)
    end divVal

    body function getNeg %() : ^mat4
	var temp : ^mat4
	new temp
	temp -> setCopy (self)
	temp -> multVal (-1)
	result temp
    end getNeg

    body function getMultVec %(M : ^vec4h) : ^vec4h
	if objectclass (M) >= vec3h then
	    put "Warning - this function (mat4.getMultVec(vec3)) is slight guesswork."
	    var temp : ^vec3h
	    new temp
	    temp -> x := vec3h (M).x * data (0) + vec3h (M).y * data (1) + vec3h (M).z * data (2) + data (3)
	    temp -> y := vec3h (M).x * data (4) + vec3h (M).y * data (5) + vec3h (M).z * data (6) + data (7)
	    temp -> z := vec3h (M).x * data (8) + vec3h (M).y * data (9) + vec3h (M).z * data (10) + data (11)
	    result temp
	elsif objectclass (M) >= vec4h then
	    var temp : ^vec4h
	    new temp
	    temp -> x := vec4h (M).x * data (0) + vec4h (M).y * data (1) + vec4h (M).z * data (2) + vec4h (M).w * data (3)
	    temp -> y := vec4h (M).x * data (4) + vec4h (M).y * data (5) + vec4h (M).z * data (6) + vec4h (M).w * data (7)
	    temp -> z := vec4h (M).x * data (8) + vec4h (M).y * data (9) + vec4h (M).z * data (10) + vec4h (M).w * data (11)
	    temp -> w := vec4h (M).x * data (12) + vec4h (M).y * data (13) + vec4h (M).z * data (14) + vec4h (M).w * data (15)
	    result temp
	else
	    put "Error in mat4.t - invalid pointer type given to getMultVec"
	    var temp : ^vec4h
	    new temp
	    temp -> x := vec4h (M).x
	    result temp
	end if
    end getMultVec

    body procedure addMat %(M : ^mat4)
	if objectclass (M) >= mat3h then
	    put "Warning - this function (mat4.addMat(mat3)) is slight guesswork."
	    data (0) += mat3h (M).data (0)
	    data (1) += mat3h (M).data (1)
	    data (2) += mat3h (M).data (2)
	    data (4) += mat3h (M).data (3)
	    data (5) += mat3h (M).data (4)
	    data (6) += mat3h (M).data (5)
	    data (8) += mat3h (M).data (6)
	    data (9) += mat3h (M).data (7)
	    data (10) += mat3h (M).data (8)
	elsif objectclass (M) >= mat4 then
	    _set (data (0) + mat4 (M).data (0), data (1) + mat4 (M).data (1),
		data (2) + mat4 (M).data (2), data (3) + mat4 (M).data (3),
		data (4) + mat4 (M).data (4), data (5) + mat4 (M).data (5),
		data (6) + mat4 (M).data (6), data (7) + mat4 (M).data (7),
		data (8) + mat4 (M).data (8), data (9) + mat4 (M).data (9),
		data (10) + mat4 (M).data (10), data (11) + mat4 (M).data (11),
		data (12) + mat4 (M).data (12), data (13) + mat4 (M).data (13),
		data (14) + mat4 (M).data (14), data (15) + mat4 (M).data (15))
	else
	    put "Error in mat4.t - invalid pointer type given to addMat"
	end if
    end addMat

    body procedure subMat %(M : ^mat3)
	if objectclass (M) >= mat3h then
	    put "Warning - this function (mat4.subMat(mat3)) is slight guesswork."
	    data (0) -= mat3h (M).data (0)
	    data (1) -= mat3h (M).data (1)
	    data (2) -= mat3h (M).data (2)
	    data (4) -= mat3h (M).data (3)
	    data (5) -= mat3h (M).data (4)
	    data (6) -= mat3h (M).data (5)
	    data (8) -= mat3h (M).data (6)
	    data (9) -= mat3h (M).data (7)
	    data (10) -= mat3h (M).data (8)
	elsif objectclass (M) >= mat4 then
	    _set (data (0) - mat4 (M).data (0), data (1) - mat4 (M).data (1),
		data (2) - mat4 (M).data (2), data (3) - mat4 (M).data (3),
		data (4) - mat4 (M).data (4), data (5) - mat4 (M).data (5),
		data (6) - mat4 (M).data (6), data (7) - mat4 (M).data (7),
		data (8) - mat4 (M).data (8), data (9) - mat4 (M).data (9),
		data (10) - mat4 (M).data (10), data (11) - mat4 (M).data (11),
		data (12) - mat4 (M).data (12), data (13) - mat4 (M).data (13),
		data (14) - mat4 (M).data (14), data (15) - mat4 (M).data (15))
	else
	    put "Error in mat4.t - invalid pointer type given to subMat"
	end if
    end subMat

    body procedure multMat %(M : ^mat3, mat4)
	if objectclass (M) >= mat3h then
	    put "Warning - this function (mat4.multMat(mat3)) is complete guesswork."
	    var temp : ^mat3h
	    new temp
	    temp -> data (0) := mat3h (M).data (0) * data (0) + mat3h (M).data (3) * data (1) + mat3h (M).data (6) * data (2)
	    temp -> data (1) := mat3h (M).data (1) * data (0) + mat3h (M).data (4) * data (1) + mat3h (M).data (7) * data (2)
	    temp -> data (2) := mat3h (M).data (2) * data (0) + mat3h (M).data (5) * data (1) + mat3h (M).data (8) * data (2)
	    temp -> data (4) := mat3h (M).data (0) * data (4) + mat3h (M).data (3) * data (5) + mat3h (M).data (6) * data (6)
	    temp -> data (5) := mat3h (M).data (1) * data (4) + mat3h (M).data (4) * data (5) + mat3h (M).data (7) * data (6)
	    temp -> data (6) := mat3h (M).data (2) * data (4) + mat3h (M).data (5) * data (5) + mat3h (M).data (8) * data (6)
	    temp -> data (8) := mat3h (M).data (0) * data (8) + mat3h (M).data (3) * data (9) + mat3h (M).data (6) * data (10)
	    temp -> data (9) := mat3h (M).data (1) * data (8) + mat3h (M).data (4) * data (9) + mat3h (M).data (7) * data (10)
	    temp -> data (10) := mat3h (M).data (2) * data (8) + mat3h (M).data (5) * data (9) + mat3h (M).data (8) * data (10)
	    setCopy (temp)
	    free temp
	elsif objectclass (M) >= mat4 then
	    var temp : ^mat4
	    new temp
	    temp -> data (0) := mat4 (M).data (0) * data (0) + mat4 (M).data (4) * data (1) + mat4 (M).data (8) * data (2) + mat4 (M).data (12) * data (3);
	    temp -> data (1) := mat4 (M).data (1) * data (0) + mat4 (M).data (5) * data (1) + mat4 (M).data (9) * data (2) + mat4 (M).data (13) * data (3);
	    temp -> data (2) := mat4 (M).data (2) * data (0) + mat4 (M).data (6) * data (1) + mat4 (M).data (10) * data (2) + mat4 (M).data (14) * data (3);
	    temp -> data (3) := mat4 (M).data (3) * data (0) + mat4 (M).data (7) * data (1) + mat4 (M).data (11) * data (2) + mat4 (M).data (15) * data (3);
	    temp -> data (4) := mat4 (M).data (0) * data (4) + mat4 (M).data (4) * data (5) + mat4 (M).data (8) * data (6) + mat4 (M).data (12) * data (7);
	    temp -> data (5) := mat4 (M).data (1) * data (4) + mat4 (M).data (5) * data (5) + mat4 (M).data (9) * data (6) + mat4 (M).data (13) * data (7);
	    temp -> data (6) := mat4 (M).data (2) * data (4) + mat4 (M).data (6) * data (5) + mat4 (M).data (10) * data (6) + mat4 (M).data (14) * data (7);
	    temp -> data (7) := mat4 (M).data (3) * data (4) + mat4 (M).data (7) * data (5) + mat4 (M).data (11) * data (6) + mat4 (M).data (15) * data (7);
	    temp -> data (8) := mat4 (M).data (0) * data (8) + mat4 (M).data (4) * data (9) + mat4 (M).data (8) * data (10) + mat4 (M).data (12) * data (11);
	    temp -> data (9) := mat4 (M).data (1) * data (8) + mat4 (M).data (5) * data (9) + mat4 (M).data (9) * data (10) + mat4 (M).data (13) * data (11);
	    temp -> data (10) := mat4 (M).data (2) * data (8) + mat4 (M).data (6) * data (9) + mat4 (M).data (10) * data (10) + mat4 (M).data (14) * data (11);
	    temp -> data (11) := mat4 (M).data (3) * data (8) + mat4 (M).data (7) * data (9) + mat4 (M).data (11) * data (10) + mat4 (M).data (15) * data (11);
	    temp -> data (12) := mat4 (M).data (0) * data (12) + mat4 (M).data (4) * data (13) + mat4 (M).data (8) * data (14) + mat4 (M).data (12) * data (15);
	    temp -> data (13) := mat4 (M).data (1) * data (12) + mat4 (M).data (5) * data (13) + mat4 (M).data (9) * data (14) + mat4 (M).data (13) * data (15);
	    temp -> data (14) := mat4 (M).data (2) * data (12) + mat4 (M).data (6) * data (13) + mat4 (M).data (10) * data (14) + mat4 (M).data (14) * data (15);
	    temp -> data (15) := mat4 (M).data (3) * data (12) + mat4 (M).data (7) * data (13) + mat4 (M).data (11) * data (14) + mat4 (M).data (15) * data (15);
	    setCopy (temp)
	    free temp
	else
	    put "Error in mat4.t - invalid pointer type given to multMat"
	end if
    end multMat

    body procedure rotateSingle %(axis : char, degrees : real)
	var rotation : ^mat4
	new rotation
	rotation -> setRotateByAxis (axis, degrees)
	multMat (rotation)
	free rotation
    end rotateSingle

    body procedure rotate %(axis : ^Vector.vec3, degrees : real)
	%Literally empty in C++

	/*var rotationX : ^mat4
	 new rotationX
	 rotationX -> setRotateByAxis ('x', degrees * axis -> x)
	 var rotationY : ^mat4
	 new rotationY
	 rotationY -> setRotateByAxis ('y', degrees * axis -> y)
	 var rotationZ : ^mat4
	 new rotationZ
	 rotationZ -> setRotateByAxis ('z', degrees * axis -> z)
	 var rotationZY : ^mat4
	 rotationZY := rotationZ -> getMult (rotationY)
	 var rotationZYX : ^mat4
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

    body procedure Translate %(translation : ^vec3)
	var temp : ^mat4
	new temp
	temp -> setTranslate (translation)
	multMat (temp)
	free temp
    end Translate

    body procedure scale %(scaleFactor : ^vec3)
	var temp : ^mat4
	new temp
	temp -> setScalar (scaleFactor)
	multMat (temp)
	free temp
    end scale

    body function getScale %(scaleFactor : ^vec3) : ^mat4
	var temp : ^mat4
	new temp
	temp -> setScalar (scaleFactor)
	temp -> multMat (self)
	result temp
    end getScale

    body procedure transpose %()
	var temp : ^mat4
	new temp
	temp -> setCopy (self)
	_set (temp -> data (0), temp -> data (4), temp -> data (8), temp -> data (12),
	    temp -> data (1), temp -> data (5), temp -> data (9), temp -> data (13),
	    temp -> data (2), temp -> data (6), temp -> data (10), temp -> data (14),
	    temp -> data (3), temp -> data (7), temp -> data (11), temp -> data (15))
	free temp
    end transpose

    body function getTranspose %() : ^mat4
	var temp : ^mat4
	new temp
	temp -> _set (data (0), data (4), data (8), data (12),
	    data (1), data (5), data (9), data (13),
	    data (2), data (6), data (10), data (14),
	    data (3), data (7), data (11), data (15))
	result temp
    end getTranspose

    body function getPos %() : ^vec3h
	var temp : ^vec3h
	new temp
	temp -> _set (data (3), data (7), data (11))
	result temp
    end getPos

    body procedure setPos %(newPos : ^vec3h)
	if objectclass (newPos) >= mat4 then
	    data (3) := vec3h (newPos).x
	    data (7) := vec3h (newPos).y
	    data (11) := vec3h (newPos).z
	else
	    put "Error in mat4.t - invalid pointer type given to setPos"
	    data (3) := vec3h (newPos).x
	end if
    end setPos

    body function getForward %() : ^vec3h
	var temp : ^vec3h
	new temp
	temp -> _set (data (3), data (6), data (10))
	result temp
    end getForward

    body function getUp %() : ^vec3h
	var temp : ^vec3h
	new temp
	temp -> _set (data (1), data (5), data (9))
	result temp
    end getUp

    body function getInverse %() : ^mat4
	%transpose the rotation and make it negative, multiply the old
	%position by this vec3, then put both together.
	var tempRot : ^mat3h
	new tempRot
	tempRot -> setCopy (self)
	var tempPos : ^vec3h
	tempPos := getPos ()
	tempRot -> transpose ()
	var negTempRot : ^mat3h
	negTempRot := tempRot -> getNeg ()
	tempPos -> mult (negTempRot)
	free negTempRot
	var final : ^mat4
	new final
	final -> setAll (tempRot, tempPos)
	free tempRot
	free tempPos
	result final
    end getInverse

    body function equals %(M : ^mat4h) : boolean
	if objectclass (M) >= mat4h then
	    result data (0) = mat4h (M).data (0) and data (1) = mat4h (M).data (1) and data (2) = mat4h (M).data (2)
		and data (3) = mat4h (M).data (3) and data (4) = mat4h (M).data (4) and data (5) = mat4h (M).data (5)
		and data (6) = mat4h (M).data (6) and data (7) = mat4h (M).data (7) and data (8) = mat4h (M).data (8)
		and data (9) = mat4h (M).data (9) and data (10) = mat4h (M).data (10) and data (11) = mat4h (M).data (11)
		and data (12) = mat4h (M).data (12) and data (13) = mat4h (M).data (13) and data (14) = mat4h (M).data (14)
		and data (15) = mat4h (M).data (15)
	else
	    put "Error in mat4.t - invalid pointer type given to equals"
	    result data (0) = mat4h (M).data (0)
	end if
    end equals

    body procedure Frustum %(fovyDegrees, aspect, near, far : real)
	var h : real := 1 / tand (fovyDegrees / 2)
	_set (h / aspect, 0, 0, 0, 0, h, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0)
	%Technically element 10 should be far / (far-near), which approaches 1,
	%and element 11 should be -(far*near) / (far - near), which approaches 0,
	%But I haven't found them to make any difference whatsoever. But here:
	data (10) := far / (far-near)
	data (11) := -(far*near) / (far - near)
    end Frustum

    body procedure Ortho %(top, bottom, left, right, near, far : real)

    end Ortho

    body procedure print %()
	put "[", data (0), ", ", data (1), ", ", data (2), ", ", data (3), "]"
	put "[", data (4), ", ", data (5), ", ", data (6), ", ", data (7), "]"
	put "[", data (8), ", ", data (9), ", ", data (10), ", ", data (11), "]"
	put "[", data (12), ", ", data (13), ", ", data (14), ", ", data (15), "]"
    end print
end mat4












