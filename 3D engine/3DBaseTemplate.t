%Kyle Blumreisinger 11/24/2021

import "Vector/vec2i.t", "Vector/vec2.t", "Vector/vec3.t", "Vector/vec3i.t", "Vector/VectorCreator.t", "Mesh.t", "Camera.t", "Light.t", "ColorManager.t"

View.Set ("graphics:600;500")
View.Set ("offscreenonly")
var deltaTime, gametimeold : int := 0
var frames, second, fps : int := 0
var font : int
font := Font.New ("serif:12")
var keyboard : array char of boolean
var running : boolean := true
var mPos : ^vec2i := vc.getVec2i(0,0)
var mPosOld : ^vec2i
new mPosOld

var cam : ^camera
new cam
cam -> create (maxx + 1, maxy + 1, 60.0, 0.1, 1000)
cam -> setSpeed (0.8)
cam -> pos -> _set (1, 1, 5) %(-3, 3, 6.1)
cam -> rot -> _set (0, 0, 0) %(-22, 220, 0)

var lights : array 0 .. 2 of ^light
for i : 0 .. 2
    new lights (i)
end for
lights (0) -> _set (1, 1, 5)

var lightPoint : ^mesh
new lightPoint
lightPoint -> createPoint ()
lightPoint -> pos -> _set (1, 1, 5)
lightPoint -> setColor(1,1,0)


%---Test meshes below---

var cube1 : ^mesh
new cube1
cube1 -> createCube ()
%cube1 -> pos -> _set (0, 0, 5)
cube1 -> setColor (0, 0, 1)

var model1 : ^mesh
new model1
model1 -> loadFromFile ("Gem")
model1 -> pos -> _set (2, 0, 0)

var cube2 : ^mesh
new cube2
cube2 -> createCube ()
cube2 -> pos -> _set (2.5, 0, 2)
%cube2 -> pos -> _set (0, 0, -5)
cube2 -> setColor (1, 0, 0)

var gimbal : ^mesh
new gimbal
gimbal -> createGimbal ()

var pointA : ^mesh
new pointA
pointA -> createPoint ()
pointA -> pos -> _set (3, 0, -2)

var triA : ^mesh
new triA
triA -> createTriangle ()

procedure handleMouse ()
    var x, y, c : int
    Mouse.Where (x, y, c)
    mPos -> x := x
    mPos -> y := y
    if c = 1 then
	var differenceVec : ^vec2
	new differenceVec
	differenceVec -> setCopy (mPos)
	differenceVec -> sub (mPosOld)
	differenceVec -> scale (0.1)
	cam -> rot -> y += differenceVec -> x
	cam -> rot -> x += differenceVec -> y
    end if
    mPosOld -> setCopy (mPos)
end handleMouse

procedure handleKeyboard (deltaTime : int)
    Input.KeyDown (keyboard)
    if keyboard ('d') or keyboard (KEY_RIGHT_ARROW) then
	cam -> move (1, 0, 0, deltaTime)
    end if
    if keyboard ('a') or keyboard (KEY_LEFT_ARROW) then
	cam -> move (-1, 0, 0, deltaTime)
    end if
    if keyboard ('w') or keyboard (KEY_UP_ARROW) then
	cam -> move (0, 0, 1, deltaTime)
    end if
    if keyboard ('s') or keyboard (KEY_DOWN_ARROW) then
	cam -> move (0, 0, -1, deltaTime)
    end if
    if keyboard (' ') or keyboard (KEY_PGUP) then
	cam -> move (0, 1, 0, deltaTime)
    end if
    if keyboard (KEY_SHIFT) or keyboard (KEY_PGDN) then
	cam -> move (0, -1, 0, deltaTime)
    end if
    if keyboard ('q') then
	cam -> rotate ('y', -8, deltaTime)
    end if
    if keyboard ('e') then
	cam -> rotate ('y', 8, deltaTime)
    end if
    if keyboard ('r') then
	cam -> rotate ('x', 8, deltaTime)
    end if
    if keyboard ('f') then
	cam -> rotate ('x', -8, deltaTime)
    end if

    if keyboard ('l') then
	cube1 -> pos -> x += 0.01
    end if
    if keyboard ('j') then
	cube1 -> pos -> x -= 0.01
    end if
    if keyboard ('i') then
	cube1 -> pos -> z += 0.01
    end if
    if keyboard ('k') then
	cube1 -> pos -> z -= 0.01
    end if
    if keyboard ('u') then
	cube1 -> pos -> y -= 0.01
    end if
    if keyboard ('o') then
	cube1 -> pos -> y += 0.01
    end if
    if keyboard ('y') then
	cube1 -> rot -> y += 0.5
    end if
    if keyboard ('h') then
	cube1 -> rot -> x += 0.5
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

    cam -> update ()

    %cam -> pos -> print ()
    %cam -> rot -> print ()
    %cam -> lookDirection -> print ()

    handleMouse ()
    handleKeyboard (deltaTime)

    cube1 -> draw (cam, lights)
    cube2 -> draw (cam, lights)
    gimbal -> draw (cam, lights)
    pointA -> draw (cam, lights)
    triA -> draw (cam, lights)
    model1 -> draw (cam, lights)
    lightPoint -> draw (cam, lights)

    Draw.Text (intstr (fps), 0, maxy - 12, font, black)

    View.Update ()
    exit when not running
end loop

cube1 -> freeData ()
cube2 -> freeData ()
gimbal -> freeData ()
pointA -> freeData ()
triA -> freeData ()
cam -> freeData ()
lightPoint -> freeData ()
for i : 0 .. 2
    lights (i) -> freeData ()
    free lights (i)
end for
free cube1
free cube2
free gimbal
free pointA
free triA
free lightPoint
free cam
