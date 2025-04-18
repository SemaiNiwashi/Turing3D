unit
class vec2i
    implement "vec2ih.t"
    import "vec2h.t", "vec3h.t", "vec3ih.t", "vec4h.t", "../Matrix/mat3h.t"

    body procedure _set %(xi, yi : int)
	x := xi
	y := yi
    end _set

    body procedure setCopy %(other : ^vec2i, vec2, vec3, vec3i, vec4)
	if objectclass (other) >= vec2i then
	    x := vec2i (other).x
	    y := vec2i (other).y
	elsif objectclass (other) >= vec2h then
	    x := floor (vec2h (other).x)
	    y := floor (vec2h (other).y)
	elsif objectclass (other) >= vec3h then
	    x := floor (vec3h (other).x)
	    y := floor (vec3h (other).y)
	elsif objectclass (other) >= vec3ih then
	    x := vec3ih (other).x
	    y := vec3ih (other).y
	elsif objectclass (other) >= vec4h then
	    x := floor (vec4h (other).x)
	    y := floor (vec4h (other).y)
	else
	    put "Error in Vec2i.t - invalid pointer type given to setCopy"
	    x := vec2i (other).x
	    y := vec2i (other).y
	end if
    end setCopy
    
    body function getCopy %() : ^vec2i
	var temp : ^vec2i
	new temp
	temp -> _set (x, y)
	result temp
    end getCopy

    body procedure addVal %(other : int)
	x += other
	y += other
    end addVal

    body procedure subVal %(other : int)
	x -= other
	y -= other
    end subVal

    body procedure scale %(scalar : real)
	x := floor (x * scalar)
	y := floor (y * scalar)
    end scale

    body procedure reduce %(scalar : real)
	x := floor (x / scalar)
	y := floor (y / scalar)
    end reduce

    body function getNeg %() : ^vec2i
	var temp : ^vec2i := getCopy()
	temp -> scale (-1)
	result temp
    end getNeg

    body procedure add %(other : ^vec2i, vec2, vec3, vec3i, vec4)
	if objectclass (other) >= vec2i then
	    x += vec2i (other).x
	    y += vec2i (other).y
	elsif objectclass (other) >= vec2h then
	    x += floor (vec2h (other).x)
	    y += floor (vec2h (other).y)
	elsif objectclass (other) >= vec3h then
	    x += floor (vec3h (other).x)
	    y += floor (vec3h (other).y)
	elsif objectclass (other) >= vec3ih then
	    x += vec3ih (other).x
	    y += vec3ih (other).y
	elsif objectclass (other) >= vec4h then
	    x += floor (vec4h (other).x)
	    y += floor (vec4h (other).y)
	else
	    put "Error in Vec2i.t - invalid pointer type given to add"
	    x += vec2i (other).x
	    y += vec2i (other).y
	end if
    end add

    body procedure sub %(other : ^vec2i, vec2, vec3, vec3i, vec4)
	if objectclass (other) >= vec2i then
	    x -= vec2i (other).x
	    y -= vec2i (other).y
	elsif objectclass (other) >= vec2h then
	    x -= floor (vec2h (other).x)
	    y -= floor (vec2h (other).y)
	elsif objectclass (other) >= vec3h then
	    x -= floor (vec3h (other).x)
	    y -= floor (vec3h (other).y)
	elsif objectclass (other) >= vec3ih then
	    x -= vec3ih (other).x
	    y -= vec3ih (other).y
	elsif objectclass (other) >= vec4h then
	    x -= floor (vec4h (other).x)
	    y -= floor (vec4h (other).y)
	else
	    put "Error in Vec2i.t - invalid pointer type given to sub"
	    x -= vec2i (other).x
	    y -= vec2i (other).y
	end if
    end sub

    body procedure mult %(other : ^vec2i, vec2, vec3, vec3i, vec4)
	if objectclass (other) >= vec2i then
	    x *= vec2i (other).x
	    y *= vec2i (other).y
	elsif objectclass (other) >= vec2h then
	    x := floor (x * vec2h (other).x)
	    y := floor (y * vec2h (other).y)
	elsif objectclass (other) >= vec3h then
	    x := floor (x * vec3h (other).x)
	    y := floor (y * vec3h (other).y)
	elsif objectclass (other) >= vec3ih then
	    x *= vec3ih (other).x
	    y *= vec3ih (other).y
	elsif objectclass (other) >= vec4h then
	    x := floor (x * vec4h (other).x)
	    y := floor (y * vec4h (other).y)
	else
	    put "Error in Vec2i.t - invalid pointer type given to mult"
	    x *= vec2i (other).x
	    y *= vec2i (other).y
	end if
    end mult

    body procedure _div %(other : ^vec2i, vec2, vec3, vec3i, vec4)
	if objectclass (other) >= vec2i then
	    x := floor (x / vec2i (other).x)
	    y := floor (y / vec2i (other).y)
	elsif objectclass (other) >= vec2h then
	    x := floor (x / vec2h (other).x)
	    y := floor (y / vec2h (other).y)
	elsif objectclass (other) >= vec3h then
	    x := floor (x / vec3h (other).x)
	    y := floor (y / vec3h (other).y)
	elsif objectclass (other) >= vec3ih then
	    x := floor (x / vec3ih (other).x)
	    y := floor (y / vec3ih (other).y)
	elsif objectclass (other) >= vec4h then
	    x := floor (x / vec4h (other).x)
	    y := floor (y / vec4h (other).y)
	else
	    put "Error in Vec2i.t - invalid pointer type given to _div"
	    x := floor (x / vec2i (other).x)
	    y := floor (y / vec2i (other).y)
	end if
    end _div

    body function asVec2 %() : ^vec2
	var temp : ^vec2h
	new temp
	temp -> setCopy (self)
	result temp
    end asVec2

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
	if objectclass (other) >= vec2i then
	    result x = vec2i (other).x and y = vec2i (other).y
	elsif objectclass (other) >= vec2h then
	    result x = vec2h (other).x and y = vec2h (other).y
	elsif objectclass (other) >= vec3h then
	    result x = vec3h (other).x and y = vec3h (other).y and vec3h (other).z = 0
	elsif objectclass (other) >= vec3ih then
	    result x = vec3ih (other).x and y = vec3ih (other).y and vec3ih (other).z = 0
	elsif objectclass (other) >= vec4h then
	    result x = vec4h (other).x and y = vec4h (other).y and vec4h (other).z = 0
	else
	    put "Error in Vec2i.t - invalid pointer type given to equals"
	    result x = vec2i (other).x and y = vec2i (other).y
	end if
    end equals

    body function Length %() : real
	result sqrt (x * x + y * y)
    end Length

    body function LengthSquared %() : real
	result x * x + y * y
    end LengthSquared

    body procedure print %()
	put "(", x, ", ", y, ")"
    end print
end vec2i











