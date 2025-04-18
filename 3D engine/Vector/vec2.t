unit
class vec2
    implement "vec2h.t"
    import "vec2ih.t", "vec3h.t", "vec3ih.t", "vec4h.t", "../Matrix/mat3h.t"

    body procedure _set %(xi, yi : real)
	x := xi
	y := yi
    end _set

    body procedure setCopy %(other : ^vec2i, vec2, vec3, vec3i, vec4)
	if objectclass (other) >= vec2ih then
	    x := vec2ih (other).x
	    y := vec2ih (other).y
	elsif objectclass (other) >= vec2 then
	    x := vec2 (other).x
	    y := vec2 (other).y
	elsif objectclass (other) >= vec3h then
	    x := vec3h (other).x
	    y := vec3h (other).y
	elsif objectclass (other) >= vec3ih then
	    x := vec3ih (other).x
	    y := vec3ih (other).y
	elsif objectclass (other) >= vec4h then
	    x := vec4h (other).x
	    y := vec4h (other).y
	else
	    put "Error in Vec2.t - invalid pointer type given to setCopy"
	    x := vec2 (other).x
	    y := vec2 (other).y
	end if
    end setCopy

    body function getCopy %() : ^vec2
	var temp : ^vec2
	new temp
	temp -> _set (x, y)
	result temp
    end getCopy

    body procedure addVal  %(other : real)
	x += other
	y += other
    end addVal

    body procedure subVal %(other : real)
	x -= other
	y -= other
    end subVal

    body procedure scale  %(scalar : real)
	x *= scalar
	y *= scalar
    end scale

    body procedure reduce %(scalar : real)
	x /= scalar
	y /= scalar
    end reduce

    body function getNeg %() : ^vec2
	var temp : ^vec2 := getCopy()
	temp -> scale (-1)
	result temp
    end getNeg

    body procedure add %(other : ^vec2i, vec2, vec3, vec3i, vec4)
	if objectclass (other) >= vec2ih then
	    x += vec2ih (other).x
	    y += vec2ih (other).y
	elsif objectclass (other) >= vec2 then
	    x += vec2 (other).x
	    y += vec2 (other).y
	elsif objectclass (other) >= vec3h then
	    x += vec3h (other).x
	    y += vec3h (other).y
	elsif objectclass (other) >= vec3ih then
	    x += vec3ih (other).x
	    y += vec3ih (other).y
	elsif objectclass (other) >= vec4h then
	    x += vec4h (other).x
	    y += vec4h (other).y
	else
	    put "Error in Vec2.t - invalid pointer type given to add"
	    x += vec2 (other).x
	    y += vec2 (other).y
	end if
    end add

    body procedure sub %(other : ^vec2i, vec2, vec3, vec3i, vec4)
	if objectclass (other) >= vec2ih then
	    x -= vec2ih (other).x
	    y -= vec2ih (other).y
	elsif objectclass (other) >= vec2 then
	    x -= vec2 (other).x
	    y -= vec2 (other).y
	elsif objectclass (other) >= vec3h then
	    x -= vec3h (other).x
	    y -= vec3h (other).y
	elsif objectclass (other) >= vec3ih then
	    x -= vec3ih (other).x
	    y -= vec3ih (other).y
	elsif objectclass (other) >= vec4h then
	    x -= vec4h (other).x
	    y -= vec4h (other).y
	else
	    put "Error in Vec2.t - invalid pointer type given to sub"
	    x -= vec2 (other).x
	    y -= vec2 (other).y
	end if
    end sub

    body procedure mult %(other : ^vec2i, vec2, vec3, vec3i, vec4)
	if objectclass (other) >= vec2ih then
	    x *= vec2ih (other).x
	    y *= vec2ih (other).y
	elsif objectclass (other) >= vec2 then
	    x *= vec2 (other).x
	    y *= vec2 (other).y
	elsif objectclass (other) >= vec3h then
	    x *= vec3h (other).x
	    y *= vec3h (other).y
	elsif objectclass (other) >= vec3ih then
	    x *= vec3ih (other).x
	    y *= vec3ih (other).y
	elsif objectclass (other) >= vec4h then
	    x *= vec4h (other).x
	    y *= vec4h (other).y
	else
	    put "Error in Vec2.t - invalid pointer type given to mult"
	    x *= vec2 (other).x
	    y *= vec2 (other).y
	end if
    end mult

    body procedure _div %(other : ^vec2i, vec2, vec3, vec3i, vec4)
	if objectclass (other) >= vec2ih then
	    x /= vec2ih (other).x
	    y /= vec2ih (other).y
	elsif objectclass (other) >= vec2 then
	    x /= vec2 (other).x
	    y /= vec2 (other).y
	elsif objectclass (other) >= vec3h then
	    x /= vec3h (other).x
	    y /= vec3h (other).y
	elsif objectclass (other) >= vec3ih then
	    x /= vec3ih (other).x
	    y /= vec3ih (other).y
	elsif objectclass (other) >= vec4h then
	    x /= vec4h (other).x
	    y /= vec4h (other).y
	else
	    put "Error in Vec2.t - invalid pointer type given to _div"
	    x /= vec2 (other).x
	    y /= vec2 (other).y
	end if
    end _div

    body function asVec2i %() : ^vec2i
	var temp : ^vec2ih
	new temp
	temp -> setCopy (self)
	result temp
    end asVec2i

    body function asVec3 %() : ^vec3
	var temp : ^vec3h
	new temp
	temp -> setCopy (self)
	result temp
    end asVec3

    body function asVec3i %() : ^vec3i
	var temp : ^vec3ih
	new temp
	temp -> setCopy (self)
	result temp
    end asVec3i

    body function asVec4 %() : ^vec4
	var temp : ^vec4h
	new temp
	temp -> setCopy (self)
	result temp
    end asVec4

    body function equals %( ^vec2i, vec2, vec3, vec3i, vec4) : boolean
	if objectclass (other) >= vec2ih then
	    result x = vec2ih (other).x and y = vec2ih (other).y
	elsif objectclass (other) >= vec2 then
	    result x = vec2 (other).x and y = vec2 (other).y
	elsif objectclass (other) >= vec3h then
	    result x = vec3h (other).x and y = vec3h (other).y and vec3h (other).z = 0
	elsif objectclass (other) >= vec3ih then
	    result x = vec3ih (other).x and y = vec3ih (other).y and vec3ih (other).z = 0
	elsif objectclass (other) >= vec4h then
	    result x = vec4h (other).x and y = vec4h (other).y and vec4h (other).z = 0
	else
	    put "Error in Vec2.t - invalid pointer type given to equals"
	    result x = vec2 (other).x and y = vec2 (other).y
	end if
    end equals

    body function Length %() : real
	result sqrt (x * x + y * y)
    end Length

    body function LengthSquared %() : real
	result x * x + y * y
    end LengthSquared

    body procedure Normalize %()
	var _length : real := Length ()
	if _length not= 0 then
	    x /= _length
	    y /= _length
	end if
    end Normalize

    body function getDirection %() : ^vec2
	var temp : ^vec2 := getCopy()
	temp -> Normalize ()
	result temp
    end getDirection

    body function getDot %(other : ^vec2) : real
	result x * other -> x + y * other -> y
    end getDot

    body procedure print %()
	put "(", x, ", ", y, ")"
    end print
end vec2











