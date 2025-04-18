%Kyle Blumreisinger 11/24/2021

View.Set ("graphics:600;500")
View.Set ("offscreenonly")
var screenWidth : int := maxx + 1
var screenHeight : int := maxy + 1
var deltaTime, gametimeold : int := 0
var frames, second, fps : int := 0
var font : int
font := Font.New ("serif:12")
var angle : real := 0
var speed : real := 0.02
var keyboard : array char of boolean
var running : boolean := true

%-------------------------------------------------------------------
class vec3
    export var x, var y, var z, _set, add, Normalize
    var x, y, z : real := 0

    procedure _set (xi, yi, zi : real)
	x := xi
	y := yi
	z := zi
    end _set

    procedure add (other : ^vec3)
	_set (x + other -> x, y + other -> y, z + other -> z)
    end add

    procedure Normalize ()
	var _length : real := sqrt (x * x + y * y + z * z)
	if _length not= 0 then
	    x /= _length
	    y /= _length
	    z /= _length
	end if
    end Normalize
end vec3

class vec4
    import vec3
    export var x, var y, var z, var w, _set
    var x, y, z, w : real := 0

    procedure _set (xi, yi, zi, wi : real)
	x := xi
	y := yi
	z := zi
	w := wi
    end _set
end vec4

class mat3
    import vec3
    %Using ROW_MAJOR order!

    export var data, _set, setCopy, setRotateByAxis, multVal, getNeg,
	getMultVec, transpose
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
	_set (other -> data (0), other -> data (1), other -> data (2),
	    other -> data (3), other -> data (4), other -> data (5),
	    other -> data (6), other -> data (7), other -> data (8))
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
	_set (data (0) * scalar, data (1) * scalar, data (2) * scalar,
	    data (3) * scalar, data (4) * scalar, data (5) * scalar,
	    data (6) * scalar, data (7) * scalar, data (8) * scalar)
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
	temp -> _set (data (0), data (1), data (2), data (3),
	    data (4), data (5), data (6), data (7), data (8))
	_set (temp -> data (0), temp -> data (3), temp -> data (6),
	    temp -> data (1), temp -> data (4), temp -> data (7),
	    temp -> data (2), temp -> data (5), temp -> data (8))
	free temp
    end transpose
end mat3

class mat4
    import vec3, vec4, mat3
    %Using ROW_MAJOR order!
    export var data, _set, setAll, setPosAndRot, getMultVec, multMat, getPos, getInverse
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
	_set (rotation -> data (0), rotation -> data (1), rotation -> data (2), position -> x,
	    rotation -> data (3), rotation -> data (4), rotation -> data (5), position -> y,
	    rotation -> data (6), rotation -> data (7), rotation -> data (8), position -> z,
	    0, 0, 0, 1)
    end setAll

    procedure setCopy (other : ^mat4)
	_set (other -> data (0), other -> data (1), other -> data (2), other -> data (3),
	    other -> data (4), other -> data (5), other -> data (6), other -> data (7),
	    other -> data (8), other -> data (9), other -> data (10), other -> data (11),
	    other -> data (12), other -> data (13), other -> data (14), other -> data (15))
    end setCopy

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
    
    function getPos () : ^vec3
	var temp : ^vec3
	new temp
	temp -> _set (data (3), data (7), data (11))
	result temp
    end getPos

    %This function is the mathimatically simplified version of doing three
    %separate rotation matrix multiplications, and is thus much faster.
    procedure setPosAndRot (posIn : ^vec3, x, y, z : real)
	if objectclass (posIn) >= vec3 then
	    _set (cosd (z) * cosd (y) + sind (z) * sind (x) * -sind (y),
		- sind (z) * cosd (y) + cosd (z) * sind (x) * -sind (y),
		cosd (x) * -sind (y), vec3 (posIn).x, sind (z) * cosd (x),
		cosd (z) * cosd (x), -sind (x), vec3 (posIn).y,
		cosd (z) * sind (y) + sind (z) * sind (x) * cosd (y),
		- sind (z) * sind (y) + cosd (z) * sind (x) * cosd (y),
		cosd (x) * cosd (y), vec3 (posIn).z, 0, 0, 0, 1)
	else
	    put "Error in mat4.t - invalid pointer type given to setPosAndRot"
	end if
    end setPosAndRot

    function getInverse () : ^mat4
	%transpose the rotation and make it negative, multiply the old
	%position by this vec3, then put both together.
	var tempRot : ^mat3
	new tempRot
	%Set tempRot to copy of self
	tempRot -> _set (data (0), data (1), data (2), data (4), data (5), data (6), data (8), data (9), data (10))
	var tempPosA := getPos ()
	tempRot -> transpose ()
	var negTempRot := tempRot -> getNeg ()
	var tempPos := negTempRot -> getMultVec (tempPosA)
	free tempPosA
	free negTempRot
	var final : ^mat4
	new final
	final -> setAll (tempRot, tempPos)
	free tempRot
	free tempPos
	result final
    end getInverse
end mat4

%Free-standing functions that couldn't work without header files so
%that vec3 could know what mat3 is and mat3 could know what vec3 is

function getRotateVecAxis (vector : ^vec3, axis : char, degrees : real) : ^vec3
    var rotation_mat : ^mat3
    new rotation_mat
    rotation_mat -> setRotateByAxis (axis, degrees)
    var temp := rotation_mat -> getMultVec (vector)
    free rotation_mat
    result temp
end getRotateVecAxis

function getRotateVecXYZ (vector : ^vec3, rotx, roty, rotz : real) : ^vec3
    var temp := getRotateVecAxis (vector, 'y', roty)         %yxz or zyx?
    var temp2 := getRotateVecAxis (temp, 'x', rotx)
    free temp
    temp := getRotateVecAxis (temp2, 'z', rotz)
    free temp2
    result temp
end getRotateVecXYZ

%-------------------------------------------------------------------

class mesh
    import screenWidth, screenHeight, var vec3, var vec4, var mat3, var mat4, getRotateVecAxis, getRotateVecXYZ
    export createCube, position, numPoints, draw, freeData
    var position : ^vec3
    new position
    position -> _set (0, 0, 0)
    var numPoints : int := 0
    var points : flexible array 0 .. -1 of ^vec3

    procedure createCube ()
	numPoints := 8
	new points, numPoints
	for i : 0 .. numPoints - 1
	    new points (i)
	end for
	points (0) -> _set (-1, -1, 1)
	points (1) -> _set (1, -1, 1)
	points (2) -> _set (1, 1, 1)
	points (3) -> _set (-1, 1, 1)
	points (4) -> _set (-1, -1, -1)
	points (5) -> _set (1, -1, -1)
	points (6) -> _set (1, 1, -1)
	points (7) -> _set (-1, 1, -1)
    end createCube

    procedure connect_point (i : int, j : int, k : array 0 .. * of ^vec3)
	Draw.Line (round (k (i) -> x), round (k (i) -> y), round (k (j) -> x), round (k (j) -> y), black)
    end connect_point

    function projectPoint (point : ^vec3, pos : ^vec3, rot : ^vec3) : ^vec3
	%Create camera transform matrix
	var transformMatrix : ^mat4
	new transformMatrix
	transformMatrix -> setPosAndRot (pos, rot -> x, rot -> y - 180, rot -> z)

	%Create view matrix (inverse of camera transform matrix)
	var viewMatrix := transformMatrix -> getInverse ()
	free transformMatrix

	%Multiply point by view matrix
	var transformed : ^vec3
	new transformed
	transformed -> _set (point -> x * viewMatrix -> data (0) + point -> y * viewMatrix -> data (1) + point -> z * viewMatrix -> data (2) + viewMatrix -> data (3),
	    point -> x * viewMatrix -> data (4) + point -> y * viewMatrix -> data (5) + point -> z * viewMatrix -> data (6) + viewMatrix -> data (7),
	    point -> x * viewMatrix -> data (8) + point -> y * viewMatrix -> data (9) + point -> z * viewMatrix -> data (10) + viewMatrix -> data (11))
	%With view matrix applied to point, point is now in camera/view space

	free viewMatrix

	%Transform view-space points into "clip space" with a projection transform
	var fov : real := 75.0
	var h : real := 1.0 / tand (fov / 2)
	%After simplification, this is all that is left of the frustum matrix
	transformed -> x *= h / (screenWidth / screenHeight)
	transformed -> y *= h
	%Technically z should be multiplied as below, but that value
	%approaches -1 and I haven't found it to make any difference whatsoever.
	%transformed->z *= (far + near) / (near - far)) + ((2 * near * far) / (near - far)
	transformed -> z *= -1 %So this is good enough

	%Here you could check z to see if within camera

	%Divide x and y by z to get homogeneous point
	transformed -> x /= transformed -> z
	transformed -> y /= transformed -> z

	%Offset point so result is normalized
	transformed -> x += 1.0
	transformed -> y += 1.0

	%Scale point to fit on screen and be centered
	transformed -> x *= screenWidth /2
	transformed -> y *= screenHeight /2

	result transformed
    end projectPoint

    procedure draw (angle : real, cam_position : ^vec3, cam_rotation : ^vec3, clr : int)
	var projected_points : array 0 .. numPoints - 1 of ^vec3

	for ind : 0 .. numPoints - 1
	    %Transform point according to mesh's scale, pos, and rotation in the world
	    var point := getRotateVecXYZ (points (ind), angle, angle, angle)
	    point -> add (position)

	    %Create modifiable version of point
	    var transformed := projectPoint (point, cam_position, cam_rotation)
	    free point

	    %z is distance from camera in depth. Things in front of the camera are positive.
	    %Crude check to make sure point is not too close / within view frustum
	    %z must not be too small
	    if transformed -> z < 0.1 then
		free transformed
		for i : 0 .. ind - 1
		    free projected_points (i)
		end for
		return
	    end if

	    new projected_points (ind)
	    projected_points (ind) ->_set(transformed->x,transformed->y,transformed->z)
	    free transformed
	    if clr not= -1 then
		Draw.FillOval (round (projected_points (ind) -> x), round (projected_points (ind) -> y), 10, 10, clr)
	    end if
	end for

	%draw edges
	if numPoints = 8 then
	    for m : 0 .. 3
		connect_point (m, (m + 1) mod 4, projected_points)
		connect_point (m + 4, (m + 1) mod 4 + 4, projected_points)
		connect_point (m, m + 4, projected_points)
	    end for
	end if

	for i : 0 .. numPoints - 1
	    free projected_points (i)
	end for
    end draw

    procedure freeData ()
	for i : 0 .. numPoints - 1
	    free points (i)
	end for
    end freeData
end mesh
%-------------------------------------------------------------------

var mPos : ^vec3
new mPos
mPos -> _set (0, 0, 0)
var mPosOld : ^vec3
new mPosOld

var cam_position : ^vec3
new cam_position
cam_position -> _set (-3, 3, 6.1)
var cam_rot : ^vec3
new cam_rot
cam_rot -> _set (-22, 220, 0)
var lookDirection : ^vec3
new lookDirection

var cube1 : ^mesh
new cube1
cube1 -> createCube ()

var cube2 : ^mesh
new cube2
cube2 -> createCube ()
cube2 -> position -> _set (2.5, 0, 2)

procedure handleMouse ()
    var x, y, c : int
    Mouse.Where (x, y, c)
    mPos -> x := x
    mPos -> y := y
    if c = 1 then
	var differenceVec : ^vec3
	new differenceVec
	differenceVec -> _set ((mPos -> x - mPosOld -> x) * 0.1, (mPos -> y - mPosOld -> y) * 0.1, 0)
	cam_rot -> y += differenceVec -> x
	cam_rot -> x += differenceVec -> y
    end if
    mPosOld -> _set (mPos -> x, mPos -> y, mPos -> z)
end handleMouse

procedure handleKeyboard ()
    Input.KeyDown (keyboard)
    var front : ^vec3
    new front
    front -> _set (lookDirection -> x * speed, lookDirection -> y * speed, lookDirection -> z * speed)
    var temp : ^vec3
    new temp
    temp -> _set (-sind (cam_rot -> y), 0, cosd (cam_rot -> y))
    var right : ^vec3
    right := getRotateVecAxis (temp, 'y', -90) %This being + or - can be changed also by swapping out line 145 of simpleMathContainerClasses.t
    free temp
    right -> _set (right -> x * speed, right -> y * speed, right -> z * speed)
    var back : ^vec3
    new back
    back -> _set (front -> x * -1, front -> y * -1, front -> z * -1)
    var left : ^vec3
    new left
    left -> _set (right -> x * -1, right -> y * -1, right -> z * -1)
    if keyboard ('d') or keyboard (KEY_RIGHT_ARROW) then
	cam_position -> add (right)
    end if
    if keyboard ('a') or keyboard (KEY_LEFT_ARROW) then
	cam_position -> add (left)
    end if
    if keyboard ('w') or keyboard (KEY_UP_ARROW) then
	cam_position -> add (front)
    end if
    if keyboard ('s') or keyboard (KEY_DOWN_ARROW) then
	cam_position -> add (back)
    end if
    if keyboard (' ') or keyboard (KEY_PGUP) then
	cam_position -> y += speed
    end if
    if keyboard (KEY_SHIFT) or keyboard (KEY_PGDN) then
	cam_position -> y -= speed
    end if
    if keyboard ('q') then
	cam_rot -> y -= speed * 8
    end if
    if keyboard ('e') then
	cam_rot -> y += speed * 8
    end if
    if keyboard ('r') then
	cam_rot -> x += speed * 8
    end if
    if keyboard ('f') then
	cam_rot -> x -= speed * 8
    end if

    free front
    free right
    free left
    free back

    if keyboard ('l') then
	cube1 -> position -> x += speed
    end if
    if keyboard ('j') then
	cube1 -> position -> x -= speed
    end if
    if keyboard ('i') then
	cube1 -> position -> z += speed
    end if
    if keyboard ('k') then
	cube1 -> position -> z -= speed
    end if
    if keyboard ('u') then
	cube1 -> position -> y -= speed
    end if
    if keyboard ('o') then
	cube1 -> position -> y += speed
    end if
    if keyboard ('y') then
	angle -= speed * 50
    end if
    if keyboard ('h') then
	angle += speed * 50
    end if

    if keyboard (KEY_ESC) then
	running := false
    end if
end handleKeyboard

loop
    deltaTime := Time.Elapsed - gametimeold
    gametimeold := Time.Elapsed
    second += deltaTime
    frames += 1
    if second >= 1000 then
	fps := frames
	second := 0
	frames := 0
    end if
    cls

    lookDirection -> _set (-cosd (cam_rot -> x) * sind (cam_rot -> y), sind (cam_rot -> x), cosd (cam_rot -> x) * cosd (cam_rot -> y))
    if lookDirection -> y not= 0 then
	lookDirection -> Normalize ()
    end if

    handleMouse ()
    handleKeyboard ()

    cube1 -> draw (angle, cam_position, cam_rot, brightblue)
    cube2 -> draw (0, cam_position, cam_rot, brightred)

    Draw.Text(intstr(fps),0,maxy-12,font,black)

    View.Update ()
    exit when not running
end loop

cube1 -> freeData ()
cube2 -> freeData ()
free cube1
free cube2
