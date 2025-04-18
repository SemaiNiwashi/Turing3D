unit
class mesh
    import "simpleMathContainerClasses.t"
    export createCube, position, numPoints, draw, freeData
    var position : ^contLib.vec3
    new position
    position -> _set (0, 0, 0)
    var numPoints : int := 0
    var points : flexible array 0 .. -1 of ^contLib.vec3

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

    procedure connect_point (i : int, j : int, k : array 0 .. * of ^contLib.vec3)
	Draw.Line (round (k (i) -> x), round (k (i) -> y), round (k (j) -> x), round (k (j) -> y), black)
    end connect_point

    procedure draw (angle : real, cam_position : ^contLib.vec3, cam_rotation : ^contLib.vec3, clr : int)
	var projected_points : array 0 .. numPoints - 1 of ^contLib.vec3
	%Don't need this because the point's "new" is called in the "asVec2i" function later
	/*for i : 0 .. numPoints
	 new projected_points (i)
	 end for*/

	for ind : 0 .. numPoints - 1
	    %Transform point according to mesh's position in the world
	    var point : ^contLib.vec3
	    point := contLib.getRotateVecXYZ (points (ind), angle, angle, angle)
	    point -> add (position)

	    
	    
	    %Create vec4 version of point
	    var transformed : ^contLib.vec4
	    new transformed
	    transformed -> setCopy (point)
	    free point
	    
	    %Create camera transform matrix
	    var transformMatrix : ^contLib.mat4
	    new transformMatrix
	    transformMatrix -> setTranslate (cam_position)
	    transformMatrix -> rotateXYZ (cam_rotation -> x, cam_rotation -> y - 180, cam_rotation -> z)

	    %Create view matrix (inverse of camera transform matrix)
	    var viewMatrix := transformMatrix -> getInverse ()
	    free transformMatrix

	    %Apply view matrix to point
	    var temp : ^contLib.vec4
	    new temp
	    temp -> setCopy (transformed)
	    free transformed
	    transformed := viewMatrix -> getMultVec (temp)
	    free temp
	    %Point is now in camera/view space
	    free viewMatrix
	    
	    %Transform view-space points into "clip space" with a projection transform
	    var cameraProjection : ^contLib.mat4
	    new cameraProjection
	    cameraProjection -> Frustum (75.0, 600 / 500, 0.1, 1000.0)
	    new temp
	    temp -> setCopy (transformed)
	    free transformed
	    transformed := cameraProjection -> getMultVec (temp)
	    free temp
	    free cameraProjection

	    %w is distance from camera in depth(?)
	    %Crude check to make sure point is not too close / within view frustum
	    %w must not be too small
	    if transformed -> w < 0.1 then
		free transformed
		for i : 0 .. ind - 1
		    free projected_points (i)
		end for
		return
	    end if

	    %Divide x, y, and z by w to get homogeneous point
	    transformed -> x /= transformed -> w
	    transformed -> y /= transformed -> w
	    transformed -> z /= transformed -> w

	    %Offset point so result is centered in screen
	    transformed -> x += 0.5
	    transformed -> y += 0.5

	    %Scale point to fit on screen
	    transformed -> x *= 600 %screenwidth
	    transformed -> y *= 500 %screenheight

	    new projected_points (ind)
	    projected_points (ind) -> x := transformed -> x
	    projected_points (ind) -> y := transformed -> y
	    projected_points (ind) -> z := 0

	    free transformed
	    Draw.FillOval (round (projected_points (ind) -> x), round (projected_points (ind) -> y), 10, 10, clr)
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











