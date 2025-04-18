unit
class vec3i
    implement "vec3ih.t"
    import "vec2ih.t", "vec2h.t", "vec3h.t", "vec4h.t", "../Matrix/mat3h.t"

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
	    x := floor (vec2h (other).x)
	    y := floor (vec2h (other).y)
	    z := 0
	elsif objectclass (other) >= vec3h then
	    x := floor (vec3h (other).x)
	    y := floor (vec3h (other).y)
	    z := floor (vec3h (other).z)
	elsif objectclass (other) >= vec3i then
	    x := vec3i (other).x
	    y := vec3i (other).y
	    z := vec3i (other).z
	elsif objectclass (other) >= vec4h then
	    x := floor (vec4h (other).x)
	    y := floor (vec4h (other).y)
	    z := floor (vec4h (other).z)
	else
	    put "Error in vec3i.t - invalid pointer type given to setCopy"
	    x := vec3i (other).x
	    y := vec3i (other).y
	    z := vec3i (other).z
	end if
    end setCopy
    
    body function getCopy %() : ^vec3i
	var temp : ^vec3i
	new temp
	temp -> _set (x, y, z)
	result temp
    end getCopy

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
	x := floor (x * scalar)
	y := floor (y * scalar)
	z := floor (z * scalar)
    end scale

    body procedure reduce %(scalar : real)
	x := floor (x / scalar)
	y := floor (y / scalar)
	z := floor (z / scalar)
    end reduce

    body function getNeg %() : ^vec3i
	var temp : ^vec3i := getCopy()
	temp -> scale (-1)
	result temp
    end getNeg

    body procedure add %(other : ^vec2i, vec2, vec3, vec3i, vec4)
	if objectclass (other) >= vec2ih then
	    x += vec2ih (other).x
	    y += vec2ih (other).y
	elsif objectclass (other) >= vec2h then
	    x += floor (vec2h (other).x)
	    y += floor (vec2h (other).y)
	elsif objectclass (other) >= vec3h then
	    x += floor (vec3h (other).x)
	    y += floor (vec3h (other).y)
	    z += floor (vec3h (other).z)
	elsif objectclass (other) >= vec3i then
	    x += vec3i (other).x
	    y += vec3i (other).y
	    z += vec3i (other).z
	elsif objectclass (other) >= vec4h then
	    x += floor (vec4h (other).x)
	    y += floor (vec4h (other).y)
	    z += floor (vec4h (other).z)
	else
	    put "Error in vec3i.t - invalid pointer type given to add"
	    x += vec3i (other).x
	    y += vec3i (other).y
	    z += vec3i (other).z
	end if
    end add

    body procedure sub %(other : ^vec2i, vec2, vec3, vec3i, vec4)
	if objectclass (other) >= vec2ih then
	    x -= vec2ih (other).x
	    y -= vec2ih (other).y
	elsif objectclass (other) >= vec2h then
	    x -= floor (vec2h (other).x)
	    y -= floor (vec2h (other).y)
	elsif objectclass (other) >= vec3h then
	    x -= floor (vec3h (other).x)
	    y -= floor (vec3h (other).y)
	    z -= floor (vec3h (other).z)
	elsif objectclass (other) >= vec3i then
	    x -= vec3i (other).x
	    y -= vec3i (other).y
	    z -= vec3i (other).z
	elsif objectclass (other) >= vec4h then
	    x -= floor (vec4h (other).x)
	    y -= floor (vec4h (other).y)
	    z -= floor (vec4h (other).z)
	else
	    put "Error in vec3i.t - invalid pointer type given to sub"
	    x -= vec3i (other).x
	    y -= vec3i (other).y
	    z -= vec3i (other).z
	end if
    end sub

    body procedure mult %(other : ^vec2i, vec2, vec3, vec3i, vec4)
	if objectclass (other) >= vec2ih then
	    x *= vec2ih (other).x
	    y *= vec2ih (other).y
	elsif objectclass (other) >= vec2h then
	    x := floor (x * vec2h (other).x)
	    y := floor (y * vec2h (other).y)
	elsif objectclass (other) >= vec3h then
	    x := floor (x * vec3h (other).x)
	    y := floor (y * vec3h (other).y)
	    z := floor (z * vec3h (other).z)
	elsif objectclass (other) >= vec3i then
	    x *= vec3i (other).x
	    y *= vec3i (other).y
	    z *= vec3i (other).z
	elsif objectclass (other) >= vec4h then
	    x := floor (x * vec4h (other).x)
	    y := floor (y * vec4h (other).y)
	    z := floor (z * vec4h (other).z)
	else
	    put "Error in vec3i.t - invalid pointer type given to mult"
	    x *= vec3i (other).x
	    y *= vec3i (other).y
	    z *= vec3i (other).z
	end if
    end mult

    body procedure _div %(other : ^vec2i, vec2, vec3, vec3i, vec4)
	if objectclass (other) >= vec2ih then
	    x := floor (x / vec2ih (other).x)
	    y := floor (y / vec2ih (other).y)
	elsif objectclass (other) >= vec2h then
	    x := floor (x / vec2h (other).x)
	    y := floor (y / vec2h (other).y)
	elsif objectclass (other) >= vec3h then
	    x := floor (x / vec3h (other).x)
	    y := floor (y / vec3h (other).y)
	    z := floor (z / vec3h (other).z)
	elsif objectclass (other) >= vec3i then
	    x := floor (x / vec3i (other).x)
	    y := floor (y / vec3i (other).y)
	    z := floor (z / vec3i (other).z)
	elsif objectclass (other) >= vec4h then
	    x := floor (x / vec4h (other).x)
	    y := floor (y / vec4h (other).y)
	    z := floor (z / vec4h (other).z)
	else
	    put "Error in vec3i.t - invalid pointer type given to _div"
	    x := floor (x / vec3i (other).x)
	    y := floor (y / vec3i (other).y)
	    z := floor (z / vec3i (other).z)
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

    body function asVec3   %() : ^vec3
	var temp : ^vec3h
	new temp
	temp -> setCopy (self)
	result temp
    end asVec3

    body function asVec4   %() : ^vec4
	var temp : ^vec4h
	new temp
	temp -> setCopy (self)
	result temp
    end asVec4

    body function equals %( ^vec2i, vec2, vec3, vec3, vec3i, vec4) : boolean
	if objectclass (other) >= vec2ih then
	    result x = vec2ih (other).x and y = vec2ih (other).y and z = 0
	elsif objectclass (other) >= vec2h then
	    result x = vec2h (other).x and y = vec2h (other).y and z = 0
	elsif objectclass (other) >= vec3h then
	    result x = vec3h (other).x and y = vec3h (other).y and z = vec3h (other).z
	elsif objectclass (other) >= vec3i then
	    result x = vec3i (other).x and y = vec3i (other).y and z = vec3i (other).z
	elsif objectclass (other) >= vec4h then
	    result x = vec4h (other).x and y = vec4h (other).y and z = vec4h (other).z
	else
	    put "Error in vec3i.t - invalid pointer type given to equals"
	    result x = vec3i (other).x and y = vec3i (other).y and z = vec3i (other).z
	end if
    end equals

    body function Length %() : real
	result sqrt (x * x + y * y + z * z)
    end Length

    body function LengthSquared %() : real
	result x * x + y * y + z * z
    end LengthSquared

    body procedure print %()
	put "[", x, ", ", y, ", ", z, "]"
    end print
end vec3i











