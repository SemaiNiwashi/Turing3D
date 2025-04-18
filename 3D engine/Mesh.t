unit
class mesh
    import "Vector/vec2i.t", "Vector/vec2.t", "Vector/vec3.t", "Vector/vec3i.t", "Vector/vec4.t", "Vector/VectorCreator.t", "Matrix/mat3.t", "Matrix/mat4.t", "Camera.t", "Light.t", "ColorManager.t"
    export createPoint, createTriangle, createCube, createGimbal, loadFromFile, setColor, pos, rot, size, scale, draw, drawWire, freeData
    var pos : ^vec3 := vc.getVec3 (0, 0, 0)
    var rot : ^vec3 := vc.getVec3 (0, 0, 0)
    var size : ^vec3 := vc.getVec3 (1, 1, 1) %Used to temporarily alter the mesh's scale when displayed
    var clr : ^vec3 := vc.getVec3(0,0,0)
    var numPoints : int := 0
    var numNormals : int := 0
    var numUvs : int := 0
    var numTris : int := 0
    var points : flexible array 0 .. -1 of ^vec3
    var normals : flexible array 0 .. -1 of ^vec3
    var uvs : flexible array 0 .. -1 of ^vec2
    %Tri is: pointInd0,pointInd1,pointIn2,normInd0,normInd1,normInd2,uvInd0,uvInd1,uvInd2
    var tris : flexible array 0 .. -1 of array 0 .. 8 of int

    %Doing "forward" for a function here causes the program to crash when
    %you try to instatiate a flexible array somewhere else. For no reason.

    procedure clearMeshData ()
	for i : 0 .. numPoints - 1
	    free points (i)
	end for
	free points
	for i : 0 .. numNormals - 1
	    free normals (i)
	end for
	free normals
	for i : 0 .. numUvs - 1
	    free uvs (i)
	end for
	free uvs
	free tris
	numPoints := 0
	numNormals := 0
	numUvs := 0
	numTris := 0
    end clearMeshData

    procedure freeData ()
	free pos
	free rot
	free size
	clearMeshData ()
    end freeData

    procedure setColor (r, g, b : real)
	clr -> _set (r, g, b)
    end setColor

    %Permanently scales the mesh's point data
    procedure scale (x, y, z : real)
	var temp : ^vec3 := vc.getVec3(x, y, z)
	for ind : 0 .. numPoints - 1
	    points (ind) -> mult (temp)
	end for
    end scale

    procedure createPoint ()
	numPoints := 1
	new points, numPoints
	new points (0)
	points (0) -> _set (0, 0, 0)
    end createPoint

    procedure createTriangle ()
	numPoints := 3
	new points, numPoints
	for i : 0 .. numPoints - 1
	    new points (i)
	end for
	points (0) -> _set (0, 0.1, 0.1)
	points (1) -> _set (0, 1.1, 0.1)
	points (2) -> _set (0, 0.6, 0.9)
	numTris := 1
	new tris, numTris
	% Front face
	tris (0) (0) := 0
	tris (0) (1) := 1
	tris (0) (2) := 2
    end createTriangle

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
	numTris := 12
	new tris, numTris
	% Front face
	tris (0) (0) := 0
	tris (0) (1) := 1
	tris (0) (2) := 2
	tris (1) (0) := 0
	tris (1) (1) := 2
	tris (1) (2) := 3
	% Right face
	tris (2) (0) := 1
	tris (2) (1) := 5
	tris (2) (2) := 6
	tris (3) (0) := 1
	tris (3) (1) := 6
	tris (3) (2) := 2
	% Back face
	tris (4) (0) := 5
	tris (4) (1) := 4
	tris (4) (2) := 7
	tris (5) (0) := 5
	tris (5) (1) := 7
	tris (5) (2) := 6
	% Left face
	tris (6) (0) := 4
	tris (6) (1) := 0
	tris (6) (2) := 3
	tris (7) (0) := 4
	tris (7) (1) := 3
	tris (7) (2) := 7
	% Top face
	tris (8) (0) := 3
	tris (8) (1) := 2
	tris (8) (2) := 6
	tris (9) (0) := 3
	tris (9) (1) := 6
	tris (9) (2) := 7
	% Bottom face
	tris (10) (0) := 0
	tris (10) (1) := 5
	tris (10) (2) := 1
	tris (11) (0) := 0
	tris (11) (1) := 4
	tris (11) (2) := 5
    end createCube

    procedure createGimbal ()
	numPoints := 4
	new points, numPoints
	for i : 0 .. numPoints - 1
	    new points (i)
	end for
	points (0) -> _set (0, 0, 0)
	points (1) -> _set (1, 0, 0)
	points (2) -> _set (0, 1, 0)
	points (3) -> _set (0, 0, 1)
    end createGimbal

    procedure loadFromFile (file : string)
	put "loading model..."

	%This setting discards other models if there's more than one in a file. May discard parts of a model if is broken up automatically by material(?)
	var discardAdditionalModels : boolean := true

	var s : int
	open : s, "Resources\\Models\\" + file + ".obj", get, seek, mod
	if s < 0 or eof (s) then
	    put "[Mesh.t] Could not open file: ", file
	    Error.Halt ("Execution terminated by thrown exception")
	    return
	end if

	var inputString : string

	var tpCrn : ^vec3 := vc.getVec3(0, 0, 0)
	var btmCrn : ^vec3 := vc.getVec3(0, 0, 0)
	var negXZ : ^vec3  := vc.getVec3(-1, 1, -1)
	var firstVertex : boolean := true
	var readingFaces, exitFile : boolean := false

	loop
	    get : s, inputString : *
	    if length (inputString) <= 1 then
		%Empty line or single character on a line - ignore.
	    elsif inputString (1) = 'v' then
		if readingFaces then
		    exit
		end if
		if inputString (2) = 't' then
		    %This line has texture data
		    numUvs += 1
		elsif inputString (2) = 'n' then
		    %This line has normal data
		    numNormals += 1
		else
		    %This line has vertex data
		    numPoints += 1
		end if
	    elsif inputString (1) = 'f' then
		%This line has face data
		if discardAdditionalModels then
		    readingFaces := true
		end if
		numTris += 1
	    end if
	    exit when eof (s)
	end loop

	new points, numPoints
	for i : 0 .. numPoints - 1
	    new points (i)
	end for
	new normals, numNormals
	for i : 0 .. numNormals - 1
	    new normals (i)
	end for
	new uvs, numUvs
	for i : 0 .. numUvs - 1
	    new uvs (i)
	end for
	new tris, numTris - 1

	var pointsRead, normalsRead, uvsRead, trisRead, lineCount : int := 0
	seek : s, 0
	readingFaces := false
	loop
	    get : s, inputString
	    if length (inputString) <= 0 then
		%Empty line - ignore.
	    elsif inputString (1) = 'v' then
		if readingFaces then
		    put "[Mesh.t] Warning: In file \"", file, "\", line ", lineCount, ": More than one model in this file; others are being ignored."
		    View.Update ()
		    delay (1000)
		    exit
		end if
		if inputString = "vt" then
		    %This line has texture data
		    for i : 0 .. 1
			get : s, inputString
			if strrealok (inputString) then
			    if i = 0 then
				uvs (uvsRead) -> x := strreal (inputString)
			    else
				uvs (uvsRead) -> y := strreal (inputString)
			    end if
			else
			    put "[Mesh.t] Error: In file \"", file, "\", line ", lineCount, ": Invalid read for texture data."
			    exitFile := true
			    exit
			end if
		    end for
		    %flip uv y axis (for some reason)
		    uvs (uvsRead) -> y := 1.0 - uvs (uvsRead) -> y
		    uvsRead += 1
		elsif inputString = "vn" then
		    %This line has normal data
		    for i : 0 .. 2
			get : s, inputString
			if strrealok (inputString) then
			    if i = 0 then
				normals (normalsRead) -> x := strreal (inputString)
			    elsif i = 1 then
				normals (normalsRead) -> y := strreal (inputString)
			    else
				normals (normalsRead) -> z := strreal (inputString)
			    end if
			else
			    put "[Mesh.t] Error: In file \"", file, "\", line ", lineCount, ": Invalid read for normal data."
			    exitFile := true
			    exit
			end if
		    end for
		    %flip normal x and z axes (for some reason)
		    normals (normalsRead) -> mult (negXZ)
		    normalsRead += 1
		else %For inputString = just "v"
		    %This line has vertex data
		    for i : 0 .. 2
			get : s, inputString
			if strrealok (inputString) then
			    if i = 0 then
				points (pointsRead) -> x := strreal (inputString)
			    elsif i = 1 then
				points (pointsRead) -> y := strreal (inputString)
			    else
				points (pointsRead) -> z := strreal (inputString)
			    end if
			else
			    put "[Mesh.t] Error: In file \"", file, "\", line ", lineCount, ": Invalid read for vertex data."
			    exitFile := true
			    exit
			end if
		    end for
		    %flip point x and z axes (for some reason)
		    points (pointsRead) -> mult (negXZ)
		    %get : s, inputString :* %Only needed if the endline didn't get consumed
		    if firstVertex then
			firstVertex := false
			tpCrn -> setCopy (points (pointsRead))
			btmCrn -> setCopy (points (pointsRead))
		    else
			if (points (pointsRead) -> x > tpCrn -> x) then
			    tpCrn -> x := points (pointsRead) -> x
			end if
			if (points (pointsRead) -> x < btmCrn -> x) then
			    btmCrn -> x := points (pointsRead) -> x
			end if
			if (points (pointsRead) -> y > tpCrn -> y) then
			    tpCrn -> y := points (pointsRead) -> y
			end if
			if (points (pointsRead) -> y < btmCrn -> y) then
			    btmCrn -> y := points (pointsRead) -> y
			end if
			if (points (pointsRead) -> z > tpCrn -> z) then
			    tpCrn -> z := points (pointsRead) -> z
			end if
			if (points (pointsRead) -> z < btmCrn -> z) then
			    btmCrn -> z := points (pointsRead) -> z
			end if
		    end if
		    pointsRead += 1
		end if
	    elsif inputString (1) = 'f' then
		%This line has face data
		if discardAdditionalModels then
		    readingFaces := true
		end if
		var indCounter : int := 0
		for i : 0 .. 2 %For the three groups on 3 indicies
		    get : s, inputString
		    for i2 : 0 .. 2 %For the 3 indicies in this group
			var posSlash : int := index (inputString, '/')
			if i2 = 2 then
			    if posSlash = 0 then
				posSlash := length (inputString) + 1
			    else
				put "[Mesh.t] Error: In file \"", file, "\", line ", lineCount, ": More than 3 verticies found in face - mesh not triangulated!"
				exitFile := true
				exit
			    end if
			end if
			if posSlash < 2 then
			    put "[Mesh.t] Error1: In file \"", file, "\", line ", lineCount, ": Invalid read for face data."
			    exitFile := true
			    exit
			end if
			var tempVal : string := inputString (1 .. posSlash - 1)
			if strintok (tempVal) then
			    tris (trisRead) (i + i2 * 3) := strint (tempVal) - 1
			else
			    put "[Mesh.t] Error2: In file \"", file, "\", line ", lineCount, ": Invalid read for face data."
			    exitFile := true
			    exit
			end if
			indCounter += 1
			if i2 not= 2 then
			    inputString := inputString (posSlash + 1 .. length (inputString))
			end if
		    end for
		    exit when exitFile
		end for
		trisRead += 1
	    else %For lines without a v or f command on them
		get : s, inputString : *
	    end if
	    lineCount += 1
	    exit when eof (s) or exitFile
	end loop
	close : s

	free tpCrn
	free btmCrn
	free negXZ
	if exitFile then
	    clearMeshData ()
	    Error.Halt ("Execution terminated by thrown exception")
	end if
    end loadFromFile

    /*procedure connect_point (i : int, j : int, k : array 0 .. * of ^vec2i)
     Draw.Line (k (i) -> x, k (i) -> y, k (j) -> x, k (j) -> y, clr)
     end connect_point*/

    procedure draw_tri (cam : ^camera, tri : array 0 .. 8 of int, k : array 0 .. * of ^vec2i, lights : array 0 .. * of ^light, doWireFrame : boolean)
	var x : array 1 .. 3 of int
	x (1) := k (tri (0)) -> x
	x (2) := k (tri (1)) -> x
	x (3) := k (tri (2)) -> x
	var y : array 1 .. 3 of int
	y (1) := k (tri (0)) -> y
	y (2) := k (tri (1)) -> y
	y (3) := k (tri (2)) -> y

	%Calculate color
	var finalClr : ^vec3 := clr -> getCopy ()

	%Do other color-y stuff.
	%finalClr->mult(lights (0) -> ambient)

	%Following https://lettier.github.io/3d-game-shaders-for-beginners/lighting.html
	/*
	 var whichVert : int := 0
	 var lightDirection : ^vec3 := lights (0) -> position -> getCopy()
	 lightDirection -> sub (points (tri (whichVert))) %subtract vertex position in 3D space

	 var normal : ^vec3
	 normal := normals (tri (whichVert + 3)) -> getNormalize () %Normalize of vertex normal

	 var unitLightDirection : ^vec3
	 unitLightDirection := lightDirection -> getNormalize ()
	 %vec3 eyeDirection       = normalize(-vertexPosition.xyz);
	 var eyeDirection : ^vec3
	 new eyeDirection
	 eyeDirection->set
	 %vec3 reflectedDirection = normalize(-reflect(unitLightDirection, normal));
	 */
	var resClr : int := clrMngr.getClr (finalClr -> x, finalClr -> y, finalClr -> z)
	free finalClr
	/*free lightDirection
	 free normal
	 free unitLightDirection
	 free eyeDirection
	 free reflectedDirection
	 */


	if doWireFrame then
	    Draw.Polygon (x, y, 3, resClr)
	    /*Draw.Line (k (tri(0)) -> x, k (tri(0)) -> y, k (tri(1)) -> x, k (tri(1)) -> y, clr)
	     Draw.Line (k (tri(1)) -> x, k (tri(1)) -> y, k (tri(2)) -> x, k (tri(2)) -> y, clr)
	     Draw.Line (k (tri(2)) -> x, k (tri(2)) -> y, k (tri(0)) -> x, k (tri(0)) -> y, clr)*/
	else
	    Draw.FillPolygon (x, y, 3, resClr)
	end if
    end draw_tri

    function pointOnScreenBuffer (point : ^vec2i, cam : ^camera, buffer : int) : boolean
	result (point -> x >= -buffer and point -> x <= cam -> screenWidth + buffer and point -> y >= -buffer and point -> y <= cam -> screenHeight + buffer)
    end pointOnScreenBuffer

    function pointOnScreen (point : ^vec2i, cam : ^camera) : boolean
	result pointOnScreenBuffer (point, cam, 0)
    end pointOnScreen

    %Very simple view frustum culling
    function triOnScreen (tri : array 0 .. 8 of int, k : array 0 .. * of ^vec2i, cam : ^camera) : boolean
	% - simply check if any of the three points is within the screen
	var visible : boolean := false
	if pointOnScreen (k (tri (0)), cam) or pointOnScreen (k (tri (1)), cam) or pointOnScreen (k (tri (2)), cam) then
	    visible := true
	end if
	% - if not, check if any of the three lines between the points intersect the screen
	% (Leaving this out until I care more)
	% - if not, the triangle may be not visible, or may just be filling the screen... aw well. RIP that tri.
	result visible
    end triOnScreen

    procedure drawWire (cam : ^camera, lights : array 0 .. * of ^light, doWireFrame : boolean)
	var projected_points : array 0 .. numPoints - 1 of ^vec2i
	var deadPoints : array 0 .. numPoints - 1 of int
	var numDeadPoints : int := 0

	for ind : 0 .. numPoints - 1
	    %Transform point according to mesh's scale, pos, and rotation in the world
	    var point : ^vec3 := points (ind) -> getCopy ()
	    point -> mult (size)
	    point -> rotate (rot)
	    point -> add (pos)

	    %Create modifiable version of point
	    var transformed := cam -> projectPointFast (point)
	    free point

	    %z is *kinda* distance from camera in depth. Things in front of the camera are positive.
	    %Crude check to make sure point is not too close (z must not be too small or negative).
	    if transformed -> z < 0.1 then
		deadPoints (numDeadPoints) := ind
		numDeadPoints += 1
	    end if

	    projected_points (ind) := transformed -> asVec2i ()
	    free transformed
	    %Draw.FillOval (projected_points (ind) -> x, projected_points (ind) -> y, 10, 10, clr)
	end for

	%draw triangles
	for i : 0 .. numTris - 1
	    %Check that triangle has no dead points (behind camera)
	    var abandonTri : boolean := false
	    for i2 : 0 .. numDeadPoints - 1
		if tris (i) (0) = deadPoints (i2) or tris (i) (1) = deadPoints (i2) or tris (i) (2) = deadPoints (i2) then
		    abandonTri := true
		    exit
		end if
	    end for
	    %check that triangle is within view frustum
	    if not abandonTri and triOnScreen (tris (i), projected_points, cam) then
		draw_tri (cam, tris (i), projected_points, lights, doWireFrame) %Draw the triangle
	    end if
	end for

	if numPoints = 1 and numTris = 0 then %Draw a point (dot)
	    %Check that point is not dead (behind camera)
	    if numDeadPoints = 0 then
		var pointMoved : ^vec3 := points (0) -> getCopy ()
		pointMoved -> add (pos)
		%This is just an approximation, and it falls apart a bit when the point is near the egde of the screen, but it's good enough.
		var camDist : real := sqrt ((cam -> pos -> x - pointMoved -> x) ** 2 + (cam -> pos -> y - pointMoved -> y) ** 2 + (cam -> pos -> z - pointMoved -> z) ** 2)
		free pointMoved
		var realSize : real := (size -> x + size -> y + size -> z) / 3
		var shownSize : int := round (realSize / camDist * 220)
		%if point is on screen
		if pointOnScreenBuffer (projected_points (0), cam, shownSize) then
		    Draw.FillOval (projected_points (0) -> x, projected_points (0) -> y, shownSize, shownSize, clrMngr.getClr (clr -> x, clr -> y, clr -> z))
		end if
	    end if
	elsif numPoints = 4 and numTris = 0 then %Draw an axis gimbal
	    %Check that point is not dead (behind camera) and on screen
	    var distA : ^vec2i := projected_points (0) -> getCopy ()
	    distA -> sub (projected_points (1))
	    var distB : ^vec2i := projected_points (0) -> getCopy ()
	    distB -> sub (projected_points (2))
	    var distC : ^vec2i := projected_points (0) -> getCopy ()
	    distC -> sub (projected_points (3))
	    var maxDist : int := max (max (round (distA -> Length ()), round (distB -> Length ())), round (distC -> Length ()))
	    free distA
	    free distB
	    free distC
	    if numDeadPoints = 0 and pointOnScreenBuffer (projected_points (0), cam, maxDist) then
		Draw.Line (projected_points (0) -> x, projected_points (0) -> y, projected_points (1) -> x, projected_points (1) -> y, brightred)
		Draw.Line (projected_points (0) -> x, projected_points (0) -> y, projected_points (2) -> x, projected_points (2) -> y, brightgreen)
		Draw.Line (projected_points (0) -> x, projected_points (0) -> y, projected_points (3) -> x, projected_points (3) -> y, brightblue)
	    end if
	end if

	for i : 0 .. numPoints - 1
	    free projected_points (i)
	end for
    end drawWire

    procedure draw (cam : ^camera, lights : array 0 .. * of ^light)
	drawWire (cam, lights, false)
    end draw
end mesh











