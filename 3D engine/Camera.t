unit
class camera
    import "Vector/vec2i.t", "Vector/vec2.t", "Vector/vec3.t", "Vector/vec3i.t", "Vector/vec4.t", "Matrix/mat3.t", "Matrix/mat4.t"
    export pos, rot, lookDirection, right, screenWidth, screenHeight, create, createFull, setSpeed, update, move, rotate, projectPoint, projectPointFast, freeData
    var pos : ^vec3
    var rot : ^vec3
    var screenWidth, screenHeight : int
    var fov, near, far : real
    var lookDirection : ^vec3
    var right : ^vec3
    var speed : real := 0.02

    deferred procedure update ()

    procedure create (screenWidthIn, screenHeightIn : int, fovIn, nearIn, farIn : real)
	new pos
	pos -> _set (0, 0, 0)
	new rot
	rot -> _set (0, 0, 0)
	new lookDirection
	lookDirection -> _set (0, 0, 1)
	new right
	screenWidth := screenWidthIn
	screenHeight := screenHeightIn
	fov := fovIn
	near := nearIn
	far := farIn
	update ()
    end create

    procedure createFull (x, y, z, rx, ry, rz : real, screenWidthIn, screenHeightIn : int, fovIn, nearIn, farIn : real)
	create (screenWidthIn, screenHeightIn, fovIn, nearIn, farIn)
	pos -> _set (x, y, z)
	rot -> _set (rx, ry, rz)
	update ()
    end createFull

    procedure setSpeed (speedIn : real)
	speed := speedIn
    end setSpeed

    body procedure update ()
	%For a camera, -z is FORWARD
	lookDirection -> _set (cosd (rot -> x) * sind (rot -> y), sind (rot -> x), -cosd (rot -> x) * cosd (rot -> y))
	right -> _set (-sind (rot -> y), 0, cosd (rot -> y))
	right -> rotateAxis ('y', 90) %This being + or - can be changed also by swapping out line 43 of mat3.t
    end update

    procedure move (x, y, z : real, deltaTime : int)
	var frontMove : ^vec3 := lookDirection -> getCopy ()
	frontMove -> scale (z * speed / 100 * deltaTime)
	var rightMove : ^vec3 := right -> getCopy ()
	rightMove -> scale (x * speed / 100 * deltaTime)
	var upMove : ^vec3
	new upMove
	upMove -> _set (0, 1, 0)
	upMove -> scale (y * speed / 100 * deltaTime)
	pos -> add (frontMove)
	pos -> add (rightMove)
	pos -> add (upMove)
	free frontMove
	free rightMove
	free upMove
    end move

    procedure rotate (axis : char, amount : real, deltaTime : int)
	if axis = 'y' then
	    rot -> y += amount * speed / 100 * deltaTime
	elsif axis = 'x' then
	    rot -> x += amount * speed / 100 * deltaTime
	elsif axis = 'z' then
	    rot -> z += amount * speed / 100 * deltaTime
	end if
    end rotate

    function projectPoint (point : ^vec3) : ^vec3
	%Create vec4 version of point
	var transformed : ^vec4
	transformed := point -> asVec4 ()

	%Create camera transform matrix
	var transformMatrix : ^mat4
	new transformMatrix
	transformMatrix -> setTranslate (pos)
	transformMatrix -> rotateXYZ (rot -> x, rot -> y, rot -> z)

	%Create view matrix (inverse of camera transform matrix)
	var viewMatrix := transformMatrix -> getInverse ()
	free transformMatrix

	%Apply view matrix to point
	transformed -> mult (viewMatrix)
	%Point is now in camera/view space
	free viewMatrix

	%Transform view-space points into "clip space" with a projection transform
	var cameraProjection : ^mat4
	new cameraProjection
	cameraProjection -> Frustum (fov, screenWidth / screenHeight, near, far)
	transformed -> mult (cameraProjection)
	free cameraProjection

	%If we divide by something too small, there will be an integer overflow error
	if abs (transformed -> w) > 0.00001 then
	    %Divide x, y, and z by w to get homogeneous point
	    transformed -> x /= abs (transformed -> w)
	    transformed -> y /= abs (transformed -> w)
	    transformed -> z /= -abs (transformed -> w)
	end if

	%Offset point so result is centered in screen
	transformed -> x += 1.0
	transformed -> y += 1.0

	%Scale point to fit on screen
	transformed -> x *= screenWidth / 2
	transformed -> y *= screenHeight / 2

	var temp : ^vec3
	temp := transformed -> asVec3 ()
	free transformed

	result temp
    end projectPoint

    function projectPointFast (point : ^vec3) : ^vec3
	%Create camera transform matrix
	var transformMatrix : ^mat4
	new transformMatrix
	transformMatrix -> setPosAndRot (pos, rot -> x, rot -> y, rot -> z)

	%Create view matrix (inverse of camera transform matrix)
	var viewMatrix := transformMatrix -> getInverse ()
	free transformMatrix

	%Multiply point by view matrix
	var transformed : ^vec3
	new transformed
	transformed -> setCopy (point)
	transformed -> mult (viewMatrix)
	%Point is now in camera/view space
	free viewMatrix

	%Transform view-space points into "clip space" with a projection transform
	var h : real := 1.0 / tand (fov / 2)
	var origZ : real := transformed -> z
	%After simplification, this is all that is left of the frustum matrix
	transformed -> x *= h / (screenWidth / screenHeight)
	transformed -> y *= h
	transformed -> z := transformed -> z * far / (far - near) - (far * near) / (far - near) %Cannot do *= here! It messes with the order of operations!

	%If we divide by something too small, there will be an integer overflow error
	if abs (origZ) > 0.00001 then
	    %Divide x, y, and z by the original z to get homogeneous point
	    transformed -> x /= abs (origZ)
	    transformed -> y /= abs (origZ)
	    transformed -> z /= -abs (origZ)
	end if

	%Offset point so result is centered in screen
	transformed -> x += 1.0
	transformed -> y += 1.0

	%Scale point to fit on screen
	transformed -> x *= screenWidth / 2
	transformed -> y *= screenHeight / 2

	result transformed
    end projectPointFast

    procedure freeData ()
	free pos
	free rot
	free lookDirection
	free right
    end freeData
end camera











