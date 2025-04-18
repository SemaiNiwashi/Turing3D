unit
class vec4
    implement "vec4h.t"
    import "vec2ih.t", "vec2h.t", "vec3h.t", "vec3ih.t", "../Matrix/mat3h.t", "../Matrix/mat4h.t"

    body procedure _set %(xi, yi, zi, wi : real)
	x := xi
	y := yi
	z := zi
	w := wi
    end _set

    body procedure setCopy %(other : ^vec2i, vec2, vec3, vec3i, vec4)
	if objectclass (other) >= vec2ih then
	    x := vec2ih (other).x
	    y := vec2ih (other).y
	    z := 0
	    w := 1
	elsif objectclass (other) >= vec2h then
	    x := vec2h (other).x
	    y := vec2h (other).y
	    z := 0
	    w := 1
	elsif objectclass (other) >= vec3h then
	    x := vec3h (other).x
	    y := vec3h (other).y
	    z := vec3h (other).z
	    w := 1
	elsif objectclass (other) >= vec3ih then
	    x := vec3ih (other).x
	    y := vec3ih (other).y
	    z := vec3ih (other).z
	    w := 1
	elsif objectclass (other) >= vec4 then
	    x := vec4 (other).x
	    y := vec4 (other).y
	    z := vec4 (other).z
	    w := vec4 (other).w
	else
	    put "Error in vec4.t - invalid pointer type given to setCopy"
	    x := vec4 (other).x
	    y := vec4 (other).y
	    z := vec4 (other).z
	    w := vec4 (other).w
	end if
    end setCopy
    
    body function getCopy %() : ^vec4
	var temp : ^vec4
	new temp
	temp -> _set (x, y, z, w)
	result temp
    end getCopy

    body procedure addVal  %(other : real)
	x += other
	y += other
	z += other
	w += other
    end addVal

    body procedure subVal  %(other : real)
	x -= other
	y -= other
	z -= other
	w -= other
    end subVal

    body procedure scale  %(scalar : real)
	x *= scalar
	y *= scalar
	z *= scalar
	w *= scalar
    end scale

    body procedure reduce %(scalar : real)
	x /= scalar
	y /= scalar
	z /= scalar
	w /= scalar
    end reduce

    body function getNeg %() : ^vec4
	var temp : ^vec4 := getCopy()
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
	elsif objectclass (other) >= vec3h then
	    x += vec3h (other).x
	    y += vec3h (other).y
	    z += vec3h (other).z
	elsif objectclass (other) >= vec3ih then
	    x += vec3ih (other).x
	    y += vec3ih (other).y
	    z += vec3ih (other).z
	elsif objectclass (other) >= vec4 then
	    x += vec4 (other).x
	    y += vec4 (other).y
	    z += vec4 (other).z
	    w += vec4 (other).w
	else
	    put "Error in vec4.t - invalid pointer type given to add"
	    x += vec4 (other).x
	    y += vec4 (other).y
	    z += vec4 (other).z
	    w += vec4 (other).w
	end if
    end add

    body procedure sub %(other : ^vec2i, vec2, vec3, vec3i, vec4)
	if objectclass (other) >= vec2ih then
	    x -= vec2ih (other).x
	    y -= vec2ih (other).y
	elsif objectclass (other) >= vec2h then
	    x -= vec2h (other).x
	    y -= vec2h (other).y
	elsif objectclass (other) >= vec3h then
	    x -= vec3h (other).x
	    y -= vec3h (other).y
	    z -= vec3h (other).z
	elsif objectclass (other) >= vec3ih then
	    x -= vec3ih (other).x
	    y -= vec3ih (other).y
	    z -= vec3ih (other).z
	elsif objectclass (other) >= vec4 then
	    x -= vec4 (other).x
	    y -= vec4 (other).y
	    z -= vec4 (other).z
	    w -= vec4 (other).w
	else
	    put "Error in vec4.t - invalid pointer type given to sub"
	    x -= vec4 (other).x
	    y -= vec4 (other).y
	    z -= vec4 (other).z
	    w -= vec4 (other).w
	end if
    end sub

    body procedure mult %(other : ^vec2i, vec2, vec3, vec3i, vec4, mat4)
	if objectclass (other) >= vec2ih then
	    x *= vec2ih (other).x
	    y *= vec2ih (other).y
	elsif objectclass (other) >= vec2h then
	    x *= vec2h (other).x
	    y *= vec2h (other).y
	elsif objectclass (other) >= vec3h then
	    x *= vec3h (other).x
	    y *= vec3h (other).y
	    z *= vec3h (other).z
	elsif objectclass (other) >= vec3ih then
	    x *= vec3ih (other).x
	    y *= vec3ih (other).y
	    z *= vec3ih (other).z
	elsif objectclass (other) >= vec4 then
	    x *= vec4 (other).x
	    y *= vec4 (other).y
	    z *= vec4 (other).z
	    w *= vec4 (other).w
	elsif objectclass (other) >= mat4h then
	    var tempx : real := x * mat4h (other).data (0) + y * mat4h (other).data (1) + z * mat4h (other).data (2) + w * mat4h (other).data (3)
	    var tempy : real := x * mat4h (other).data (4) + y * mat4h (other).data (5) + z * mat4h (other).data (6) + w * mat4h (other).data (7)
	    var tempz : real := x * mat4h (other).data (8) + y * mat4h (other).data (9) + z * mat4h (other).data (10) + w * mat4h (other).data (11)
	    var tempw : real := x * mat4h (other).data (12) + y * mat4h (other).data (13) + z * mat4h (other).data (14) + w * mat4h (other).data (15)
	    x := tempx
	    y := tempy
	    z := tempz
	    w := tempw
	else
	    put "Error in vec4.t - invalid pointer type given to mult"
	    x *= vec4 (other).x
	    y *= vec4 (other).y
	    z *= vec4 (other).z
	    w *= vec4 (other).w
	end if
    end mult

    body procedure _div %(other : ^vec2i, vec2, vec3, vec3i, vec4)
	if objectclass (other) >= vec2ih then
	    x /= vec2ih (other).x
	    y /= vec2ih (other).y
	elsif objectclass (other) >= vec2h then
	    x /= vec2h (other).x
	    y /= vec2h (other).y
	elsif objectclass (other) >= vec3h then
	    x /= vec3h (other).x
	    y /= vec3h (other).y
	    z /= vec3h (other).z
	elsif objectclass (other) >= vec3ih then
	    x /= vec3ih (other).x
	    y /= vec3ih (other).y
	    z /= vec3ih (other).z
	elsif objectclass (other) >= vec4 then
	    x /= vec4 (other).x
	    y /= vec4 (other).y
	    z /= vec4 (other).z
	    w /= vec4 (other).w
	else
	    put "Error in vec4.t - invalid pointer type given to _div"
	    x /= vec4 (other).x
	    y /= vec4 (other).y
	    z /= vec4 (other).z
	    w /= vec4 (other).w
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

    body function asVec3    %() : ^vec3
	var temp : ^vec3h
	new temp
	temp -> setCopy (self)
	result temp
    end asVec3

    body function asVec3i    %() : ^vec3i
	var temp : ^vec3ih
	new temp
	temp -> setCopy (self)
	result temp
    end asVec3i

    body function equals %( ^vec2i, vec2, vec3, vec3i, vec4) : boolean
	if objectclass (other) >= vec2ih then
	    result x = vec2ih (other).x and y = vec2ih (other).y and z = 0 and w = 0
	elsif objectclass (other) >= vec2h then
	    result x = vec2h (other).x and y = vec2h (other).y and z = 0 and w = 0
	elsif objectclass (other) >= vec3h then
	    result x = vec3h (other).x and y = vec3h (other).y and z = vec3h (other).z and w = 0
	elsif objectclass (other) >= vec3ih then
	    result x = vec3ih (other).x and y = vec3ih (other).y and z = vec3ih (other).z and w = 0
	elsif objectclass (other) >= vec4 then
	    result x = vec4 (other).x and y = vec4 (other).y and z = vec4 (other).z and w = vec4 (other).w
	else
	    put "Error in vec3.t - invalid pointer type given to equals"
	    result x = vec4 (other).x and y = vec4 (other).y and z = vec4 (other).z and w = vec4 (other).w
	end if
    end equals

    body function Length %() : real
	result sqrt (x * x + y * y + z * z + w * w)
    end Length

    body function LengthSquared %() : real
	result x * x + y * y + z * z + w * w
    end LengthSquared

    body procedure Normalize %()
	var _length : real := Length ()
	if _length not= 0 then
	    x /= _length
	    y /= _length
	    z /= _length
	    w /= _length
	end if
    end Normalize

    body function getNormalize %() : ^vec4
	var temp : ^vec4h := getCopy()
	temp -> Normalize ()
	result temp
    end getNormalize

    body function getDot %(other : ^vec3) : real
	result x * other -> x + y * other -> y + z * other -> z + w * other -> w
    end getDot

    body procedure print %()
	put "[", x, ", ", y, ", ", z, ", ", w, "]"
    end print
end vec4











