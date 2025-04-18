%source: https://www.youtube.com/watch?v=sSQIwIx8uT4
%Modified by Kyle Blumreisinger 11/19/2021

%from icosphere import verticies <- python
View.Set ("graphics:600;400")
View.Set ("offscreenonly")

function matrix_multiplication3b3 (a : array 0 .. 2 of array 0 .. 2 of real, b : array 0 .. 2 of real, temppp : boolean) : array 0 .. 2 of real
    var columns_a : int := 3
    var rows_a : int := 3
    var columns_b : int := 1
    var rows_b : int := 3

    var result_vector : array 0 .. 2 of real := init (0, 0, 0)
    for x : 0 .. rows_a - 1
	var sum : real := 0
	for k : 0 .. columns_a - 1
	    sum += a (x) (k) * b (k)
	end for
	result_vector (x) := sum
    end for
    result result_vector
end matrix_multiplication3b3

function matrix_multiplication2b3 (a : array 0 .. 1 of array 0 .. 2 of real, b : array 0 .. 2 of real) : array 0 .. 1 of real
    var columns_a : int := 3
    var rows_a : int := 2
    var columns_b : int := 1
    var rows_b : int := 3

    var result_vector : array 0 .. 1 of real := init (0, 0)
    for x : 0 .. rows_a - 1
	var sum : real := 0
	for k : 0 .. columns_a - 1
	    sum += a (x) (k) * b (k)
	end for
	result_vector (x) := sum
    end for
    result result_vector
end matrix_multiplication2b3

var width : int := maxx + 1
var height : int := maxy + 1

var deltaTime, gametimeold : int := 0

var angle : real := 0
var cube_position : array 0 .. 1 of int
cube_position (0) := width div 2
cube_position (1) := height div 2
var scale : real := 600
var speed : real := 0.001

%points = verticies
var points : array 0 .. 7 of array 0 .. 2 of real := init (
    init (-1, -1, 1),
    init (1, -1, 1),
    init (1, 1, 1),
    init (-1, 1, 1),
    init (-1, -1, -1),
    init (1, -1, -1),
    init (1, 1, -1),
    init (-1, 1, -1))

procedure connect_point (i : int, j : int, k : array 0 .. 7 of array 0 .. 1 of int)
    var a : array 0 .. 2 of int
    a (0) := k (i) (0)
    a (1) := k (i) (1)
    var b : array 0 .. 2 of int
    b (0) := k (j) (0)
    b (1) := k (j) (1)
    Draw.Line (a (0), maxy - a (1), b (0), maxy - b (1), black)
end connect_point

%Move cube right
/*for i : 0..7
    points(i)(0) += 1.4
end for*/

loop
    deltaTime := Time.Elapsed - gametimeold
    gametimeold := Time.Elapsed
    cls
    var projected_points : array 0 .. 7 of array 0 .. 1 of int

    var rotation_x : array 0 .. 2 of array 0 .. 2 of real
    rotation_x (0) (0) := 1
    rotation_x (0) (1) := 0
    rotation_x (0) (2) := 0
    rotation_x (1) (0) := 0
    rotation_x (1) (1) := cos (angle)
    rotation_x (1) (2) := -sin (angle)
    rotation_x (2) (0) := 0
    rotation_x (2) (1) := sin (angle)
    rotation_x (2) (2) := cos (angle)

    var rotation_y : array 0 .. 2 of array 0 .. 2 of real
    rotation_y (0) (0) := cos (angle)
    rotation_y (0) (1) := 0
    rotation_y (0) (2) := -sin (angle)
    rotation_y (1) (0) := 0
    rotation_y (1) (1) := 1
    rotation_y (1) (2) := 0
    rotation_y (2) (0) := sin (angle)
    rotation_y (2) (1) := 0
    rotation_y (2) (2) := cos (angle)

    var rotation_z : array 0 .. 2 of array 0 .. 2 of real
    rotation_z (0) (0) := cos (angle)
    rotation_z (0) (1) := -sin (angle)
    rotation_z (0) (2) := 0
    rotation_z (1) (0) := sin (angle)
    rotation_z (1) (1) := cos (angle)
    rotation_z (1) (2) := 0
    rotation_z (2) (0) := 0
    rotation_z (2) (1) := 0
    rotation_z (2) (2) := 1

    for ind : 0 .. 7
	var rotated_2d : array 0 .. 2 of real := matrix_multiplication3b3 (rotation_y, points (ind), false)
	rotated_2d := matrix_multiplication3b3 (rotation_x, rotated_2d, ind = 0)
	rotated_2d := matrix_multiplication3b3 (rotation_z, rotated_2d, false)

	var distance : real := 5
	
	%var M_PI : real := 3.14159265358979323846
	%var z : real := 1.0 / (tan (((M_PI / 180) * 75) / 2))
	
	var tangent : real := 1.0 / (distance - rotated_2d (2))
	var projection_matrix : array 0 .. 1 of array 0 .. 2 of real
	projection_matrix (0) (0) := tangent
	projection_matrix (0) (1) := 0
	projection_matrix (0) (2) := 0
	projection_matrix (1) (0) := 0
	projection_matrix (1) (1) := tangent
	projection_matrix (1) (2) := 0

	var projected_2d : array 0 .. 1 of real := matrix_multiplication2b3 (projection_matrix, rotated_2d)

	var x : int := floor (projected_2d (0) * scale) + cube_position (0)
	var y : int := floor (projected_2d (1) * scale) + cube_position (1)
	projected_points (ind) (0) := x
	projected_points (ind) (1) := y

	Draw.FillOval (x, maxy - y, 10, 10, brightblue)
    end for

    %draw edges
    for m : 0 .. 3
	connect_point (m, (m + 1) mod 4, projected_points)
	connect_point (m + 4, (m + 1) mod 4 + 4, projected_points)
	connect_point (m, m + 4, projected_points)
    end for
    
    angle += speed * deltaTime
    View.Update ()
end loop
