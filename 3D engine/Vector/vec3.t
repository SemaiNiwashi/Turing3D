unit
class vec3
    implement "vec3h.t"
    import "vec2ih.t", "vec2h.t", "vec3ih.t", "vec4h.t", "../Matrix/mat3h.t", "../Matrix/mat4h.t"

    body procedure _set %(xi, yi, zi : real)
	x := xi
	y := yi
	z := zi
    end _set

    body procedure setCopy %(other : ^vec2i, vec2, vec3, vec3i, vec4)
	if objectclass (other) >= vec2ih then
	    x := vec2ih (other).x
	    y := vec2ih (other).y
	    z := 0
	elsif objectclass (other) >= vec2h then
	    x := vec2h (other).x
	    y := vec2h (other).y
	    z := 0
	elsif objectclass (other) >= vec3 then
	    x := vec3 (other).x
	    y := vec3 (other).y
	    z := vec3 (other).z
	elsif objectclass (other) >= vec3ih then
	    x := vec3ih (other).x
	    y := vec3ih (other).y
	    z := vec3ih (other).z
	elsif objectclass (other) >= vec4h then
	    x := vec4h (other).x
	    y := vec4h (other).y
	    z := vec4h (other).z
	else
	    put "Error in vec3.t - invalid pointer type given to setCopy"
	    x := vec3 (other).x
	    y := vec3 (other).y
	    z := vec3 (other).z
	end if
    end setCopy

    body function getCopy %() : ^vec3
	var temp : ^vec3
	new temp
	temp -> _set (x, y, z)
	result temp
    end getCopy

    body procedure setXY %(other : ^anyclass) %vec2i, vec2, vec3, vec3i, vec4
	if objectclass (other) >= vec2ih then
	    x := vec2ih (other).x
	    y := vec2ih (other).y
	elsif objectclass (other) >= vec2h then
	    x := vec2h (other).x
	    y := vec2h (other).y
	elsif objectclass (other) >= vec3 then
	    x := vec3 (other).x
	    y := vec3 (other).y
	elsif objectclass (other) >= vec3ih then
	    x := vec3ih (other).x
	    y := vec3ih (other).y
	elsif objectclass (other) >= vec4h then
	    x := vec4h (other).x
	    y := vec4h (other).y
	else
	    put "Error in vec3.t - invalid pointer type given to setXY"
	    x := vec3 (other).x
	    y := vec3 (other).y
	end if
    end setXY

    body procedure SetAnglesFromVector %()
	var M_PI : real := 3.14159265358979323846
	var original : ^vec3
	new original
	original -> _set (x, y, z)
	y := 90 + arctan (original -> z / original -> x) * (180.0 / M_PI)
	if original -> x < 0 then
	    y -= 180
	    y := 360 + y
	end if
	x := arctan (original -> y / (sqrt (original -> x * original -> x + original -> z * original -> z))) * (180.0 / M_PI) * -1
	z := 0
	free original
    end SetAnglesFromVector

    body procedure SetAnglesFromOtherVector %(other : ^vec3)
	var M_PI : real := 3.14159265358979323846
	y := 90 + arctan (other -> z / other -> x) * (180.0 / M_PI)
	if other -> x < 0 then
	    y -= 180
	    y := 360 + y
	end if
	x := arctan (other -> y / (sqrt (other -> x * other -> x + other -> z * other -> z))) * (180.0 / M_PI) * -1
	z := 0
    end SetAnglesFromOtherVector

    body function GetAnglesFromVector %() : ^vec3
	var M_PI : real := 3.14159265358979323846
	var temp : ^vec3
	new temp
	temp -> y := 90 + arctan (z / x) * (180.0 / M_PI)
	if x < 0 then
	    temp -> y -= 180
	    temp -> y := 360 + temp -> y
	end if
	temp -> x := arctan (y / (sqrt (x * x + z * z))) * (180.0 / M_PI) * -1
	temp -> z := 0
	result temp
    end GetAnglesFromVector

    body procedure addVal  %(other : real)
	x += other
	y += other
	z += other
    end addVal

    body procedure subVal  %(other : real)
	x -= other
	y -= other
	z -= other
    end subVal

    body procedure scale  %(scalar : real)
	x *= scalar
	y *= scalar
	z *= scalar
    end scale

    body procedure reduce %(scalar : real)
	x /= scalar
	y /= scalar
	z /= scalar
    end reduce

    body function getNeg %() : ^vec3
	var temp : ^vec3 := getCopy()
	temp -> scale (-1)
	result temp
    end getNeg

    body procedure add %(other : ^vec2i, vec2, vec3, vec3i, vec4)
	if objectclass (other) >= vec2ih then
	    x += vec2ih (other).x
	    y += vec2ih (other).y
	elsif objectclass (other) >= vec2h then
	    x += vec2h (other).x
	    y += vec2h (other).y
	elsif objectclass (other) >= vec3 then
	    x += vec3 (other).x
	    y += vec3 (other).y
	    z += vec3 (other).z
	elsif objectclass (other) >= vec3ih then
	    x += vec3ih (other).x
	    y += vec3ih (other).y
	    z += vec3ih (other).z
	elsif objectclass (other) >= vec4h then
	    x += vec4h (other).x
	    y += vec4h (other).y
	    z += vec4h (other).z
	else
	    put "Error in vec3.t - invalid pointer type given to add"
	    x += vec3 (other).x
	    y += vec3 (other).y
	    z += vec3 (other).z
	end if
    end add

    body procedure sub %(other : ^vec2i, vec2, vec3, vec3i, vec4)
	if objectclass (other) >= vec2ih then
	    x -= vec2ih (other).x
	    y -= vec2ih (other).y
	elsif objectclass (other) >= vec2h then
	    x -= vec2h (other).x
	    y -= vec2h (other).y
	elsif objectclass (other) >= vec3 then
	    x -= vec3 (other).x
	    y -= vec3 (other).y
	    z -= vec3 (other).z
	elsif objectclass (other) >= vec3ih then
	    x -= vec3ih (other).x
	    y -= vec3ih (other).y
	    z -= vec3ih (other).z
	elsif objectclass (other) >= vec4h then
	    x -= vec4h (other).x
	    y -= vec4h (other).y
	    z -= vec4h (other).z
	else
	    put "Error in vec3.t - invalid pointer type given to sub"
	    x -= vec3 (other).x
	    y -= vec3 (other).y
	    z -= vec3 (other).z
	end if
    end sub

    body procedure mult %(other : ^vec2i, vec2, vec3, vec3i, vec4, mat3, mat4)
	if objectclass (other) >= vec2ih then
	    x *= vec2ih (other).x
	    y *= vec2ih (other).y
	elsif objectclass (other) >= vec2h then
	    x *= vec2h (other).x
	    y *= vec2h (other).y
	elsif objectclass (other) >= vec3 then
	    x *= vec3 (other).x
	    y *= vec3 (other).y
	    z *= vec3 (other).z
	elsif objectclass (other) >= vec3ih then
	    x *= vec3ih (other).x
	    y *= vec3ih (other).y
	    z *= vec3ih (other).z
	elsif objectclass (other) >= vec4h then
	    x *= vec4h (other).x
	    y *= vec4h (other).y
	    z *= vec4h (other).z
	elsif objectclass (other) >= mat3h then
	    var tempx : real := x * mat3h (other).data (0) + y * mat3h (other).data (1) + z * mat3h (other).data (2)
	    var tempy : real := x * mat3h (other).data (3) + y * mat3h (other).data (4) + z * mat3h (other).data (5)
	    var tempz : real := x * mat3h (other).data (6) + y * mat3h (other).data (7) + z * mat3h (other).data (8)
	    x := tempx
	    y := tempy
	    z := tempz
	elsif objectclass (other) >= mat4h then
	    %put "Warning - this function (vec3.mult(mat4)) only works when the matrix only holds rotation data(?)"
	    var tempx : real := x * mat4h (other).data (0) + y * mat4h (other).data (1) + z * mat4h (other).data (2) + mat4h (other).data (3)
	    var tempy : real := x * mat4h (other).data (4) + y * mat4h (other).data (5) + z * mat4h (other).data (6) + mat4h (other).data (7)
	    var tempz : real := x * mat4h (other).data (8) + y * mat4h (other).data (9) + z * mat4h (other).data (10) + mat4h (other).data (11)
	    x := tempx
	    y := tempy
	    z := tempz
	else
	    put "Error in vec3.t - invalid pointer type given to mult"
	    x *= vec3 (other).x
	    y *= vec3 (other).y
	    z *= vec3 (other).z
	end if
    end mult

    body procedure _div %(other : ^vec2i, vec2, vec3, vec3i, vec4)
	if objectclass (other) >= vec2ih then
	    x /= vec2ih (other).x
	    y /= vec2ih (other).y
	elsif objectclass (other) >= vec2h then
	    x /= vec2h (other).x
	    y /= vec2h (other).y
	elsif objectclass (other) >= vec3 then
	    x /= vec3 (other).x
	    y /= vec3 (other).y
	    z /= vec3 (other).z
	elsif objectclass (other) >= vec3ih then
	    x /= vec3ih (other).x
	    y /= vec3ih (other).y
	    z /= vec3ih (other).z
	elsif objectclass (other) >= vec4h then
	    x /= vec4h (other).x
	    y /= vec4h (other).y
	    z /= vec4h (other).z
	else
	    put "Error in vec3.t - invalid pointer type given to _div"
	    x /= vec3 (other).x
	    y /= vec3 (other).y
	    z /= vec3 (other).z
	end if
    end _div

    body function asVec2i %() : ^vec2i
	var temp : ^vec2ih
	new temp
	temp -> setCopy (self)
	result temp
    end asVec2i

    body function asVec2  %() : ^vec2
	var temp : ^vec2h
	new temp
	temp -> setCopy (self)
	result temp
    end asVec2

    body function asVec3i  %() : ^vec3i
	var temp : ^vec3ih
	new temp
	temp -> setCopy (self)
	result temp
    end asVec3i

    body function asVec4  %() : ^vec4
	var temp : ^vec4h
	new temp
	temp -> setCopy (self)
	result temp
    end asVec4

    body function equals %( ^vec2i, vec2, vec3, vec3i, vec4) : boolean
	if objectclass (other) >= vec2ih then
	    result x = vec2ih (other).x and y = vec2ih (other).y and z = 0
	elsif objectclass (other) >= vec2h then
	    result x = vec2h (other).x and y = vec2h (other).y and z = 0
	elsif objectclass (other) >= vec3 then
	    result x = vec3 (other).x and y = vec3 (other).y and z = vec3 (other).z
	elsif objectclass (other) >= vec3ih then
	    result x = vec3ih (other).x and y = vec3ih (other).y and z = vec3ih (other).z
	elsif objectclass (other) >= vec4h then
	    result x = vec4h (other).x and y = vec4h (other).y and z = vec4h (other).z
	else
	    put "Error in vec3.t - invalid pointer type given to equals"
	    result x = vec3 (other).x and y = vec3 (other).y and z = vec3 (other).z
	end if
    end equals

    body function Length %() : real
	result sqrt (x * x + y * y + z * z)
    end Length

    body function LengthSquared %() : real
	result x * x + y * y + z * z
    end LengthSquared

    body procedure Normalize %()
	var _length : real := Length ()
	if _length not= 0 then
	    x /= _length
	    y /= _length
	    z /= _length
	end if
    end Normalize

    body function getNormalize %() : ^vec3
	var temp : ^vec3 := getCopy()
	temp -> Normalize ()
	result temp
    end getNormalize

    body function getDot %(other : ^vec3) : real
	result x * other -> x + y * other -> y + z * other -> z
    end getDot

    body function getCross %(other : ^vec3) : ^vec3
	var temp : ^vec3
	new temp
	temp -> _set (y * other -> z - z * other -> y,
	    z * other -> x - x * other -> z,
	    x * other -> y - y * other -> x)
	result temp
    end getCross

    body procedure rotateAxis %(axis : char, degrees : real)
	var rotation_mat : ^mat3h
	new rotation_mat
	rotation_mat -> setRotateByAxis (axis, degrees)
	var temp : ^vec3
	temp := rotation_mat -> getMultVec (self)
	setCopy (temp)
	free temp
	free rotation_mat
    end rotateAxis

    body function getRotateAxis %(axis : char, degrees : real) : ^vec3
	var rotation_mat : ^mat3h
	new rotation_mat
	rotation_mat -> setRotateByAxis (axis, degrees)
	var temp : ^vec3
	temp := rotation_mat -> getMultVec (self)
	free rotation_mat
	result temp
    end getRotateAxis

    body procedure rotateXYZ %(rotx, roty, rotz : real)
	rotateAxis ('y', roty) %yxz or zyx? (don't forget BOTH places!)
	rotateAxis ('x', rotx)
	rotateAxis ('z', rotz)
    end rotateXYZ

    body function getRotateXYZ %(rotx, roty, rotz : real) : ^vec3
	var temp : ^vec3
	temp := getRotateAxis ('y', roty) %yxz or zyx? (don't forget BOTH places!)
	temp -> rotateAxis ('x', rotx)
	temp -> rotateAxis ('z', rotz)
	result temp
    end getRotateXYZ

    body procedure rotate %(rot : ^vec3)
	rotateXYZ (rot -> x, rot -> y, rot -> z)
    end rotate

    body function getRotate %(rot : ^vec3) : ^vec3
	result getRotateXYZ (rot -> x, rot -> y, rot -> z)
    end getRotate

    body procedure rotateAxisVecXYZ %(axisX, axisY, axisZ : real, degrees : real)
	rotateXYZ (degrees * axisX, degrees * axisY, degrees * axisY)
    end rotateAxisVecXYZ

    body function getRotateAxisVecXYZ %(axisX, axisY, axisZ : real, degrees : real) : ^vec3
	result getRotateXYZ (degrees * axisX, degrees * axisY, degrees * axisY)
    end getRotateAxisVecXYZ

    body procedure rotateAxisVec %(axis : ^vec3, degrees : real)
	rotateXYZ (degrees * axis -> x, degrees * axis -> y, degrees * axis -> z)
    end rotateAxisVec

    body function getRotateAxisVec %(axis : ^vec3, degrees : real) : ^vec3
	result getRotateXYZ (degrees * axis -> x, degrees * axis -> y, degrees * axis -> z)
    end getRotateAxisVec

    body procedure print %()
	put "[", x, ", ", y, ", ", z, "]"
    end print
end vec3











