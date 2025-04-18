unit
module primitiveDraw
    import "Mesh.t", "Camera.t"
    export DrawCube

    procedure DrawCube (x, y, z, sx, sy, sz, rx, ry, rz : real, cam : ^camera)
	var cube : ^mesh
	new cube
	cube -> createCube ()
	cube -> pos -> _set (x, y, z)
	cube -> size -> _set (sx, sy, sz)
	cube -> rot -> _set (rx, ry, rz)
	cube -> setWireColor (brightblue)
	cube -> draw (cam)
	cube -> freeData ()
	free cube
    end DrawCube
end primitiveDraw
