%Kyle Blumreisinger 11/24/2021

import "simpleMathContainerClasses.t", "Mesh.t"

View.Set ("graphics:600;500")
View.Set ("offscreenonly")
var width : int := maxx + 1
var height : int := maxy + 1
var deltaTime, gametimeold : int := 0
var angle : real := 0
var speed : real := 0.05
var keyboard : array char of boolean
var running : boolean := true
var mPos : ^contLib.vec3
new mPos
mPos -> _set (0, 0, 0)
var mPosOld : ^contLib.vec3
new mPosOld

var cam_position : ^contLib.vec3
new cam_position
cam_position -> _set (1, 1, 5)
var cam_rot : ^contLib.vec3
new cam_rot
cam_rot -> _set (0, 180, 0)
var lookDirection : ^contLib.vec3
new lookDirection


%test1.test()
%quit

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
	var differenceVec : ^contLib.vec3
	new differenceVec
	differenceVec -> setCopy (mPos)
	differenceVec -> sub (mPosOld)
	differenceVec -> scale (0.1)
	cam_rot -> y += differenceVec -> x
	cam_rot -> x += differenceVec -> y
    end if
    mPosOld -> setCopy (mPos)
end handleMouse

procedure handleKeyboard ()
    Input.KeyDown (keyboard)
    var front : ^contLib.vec3
    new front
    front -> setCopy (lookDirection)
    front -> scale (0.01)
    var temp : ^contLib.vec3
    new temp
    temp -> x := -sind (cam_rot -> y)
    temp -> y := 0
    temp -> z := cosd (cam_rot -> y)
    var right : ^contLib.vec3
    right := contLib.getRotateVecAxis(temp,'y', -90) %This being + or - can be changed also by swapping out line 145 of simpleMathContainerClasses.t
    free temp
    right -> scale (0.01)
    var back : ^contLib.vec3
    new back
    back -> setCopy (front)
    back -> scale (-1)
    var left : ^contLib.vec3
    new left
    left -> setCopy (right)
    left -> scale (-1)
    if keyboard ('d') or keyboard (KEY_RIGHT_ARROW) then
	%cam_position -> x += 0.01
	cam_position -> add (right)
    end if
    if keyboard ('a') or keyboard (KEY_LEFT_ARROW) then
	%cam_position -> x -= 0.01
	cam_position -> add (left)
    end if
    if keyboard ('w') or keyboard (KEY_UP_ARROW) then
	%cam_position -> z += 0.01
	cam_position -> add (front)
    end if
    if keyboard ('s') or keyboard (KEY_DOWN_ARROW) then
	%cam_position -> z -= 0.01
	cam_position -> add (back)
    end if
    if keyboard (' ') or keyboard (KEY_PGUP) then
	cam_position -> y += 0.01
    end if
    if keyboard (KEY_SHIFT) or keyboard (KEY_PGDN) then
	cam_position -> y -= 0.01
    end if
    if keyboard ('q') then
	cam_rot -> y -= 0.5
    end if
    if keyboard ('e') then
	cam_rot -> y += 0.5
    end if
    if keyboard ('r') then
	cam_rot -> x += 0.5
    end if
    if keyboard ('f') then
	cam_rot -> x -= 0.5
    end if

    free front
    free right
    free left
    free back

    if keyboard ('l') then
	cube1 -> position -> x += 0.01
    end if
    if keyboard ('j') then
	cube1 -> position -> x -= 0.01
    end if
    if keyboard ('i') then
	cube1 -> position -> z += 0.01
    end if
    if keyboard ('k') then
	cube1 -> position -> z -= 0.01
    end if
    if keyboard ('u') then
	cube1 -> position -> y -= 0.01
    end if
    if keyboard ('o') then
	cube1 -> position -> y += 0.01
    end if
    /*if keyboard ('y') then
     cube1 -> position -> y -= 0.01
     end if
     if keyboard ('h') then
     cube1 -> position -> y += 0.01
     end if*/

    if keyboard (KEY_ESC) then
	running := false
    end if
end handleKeyboard

loop
    deltaTime := Time.Elapsed - gametimeold
    gametimeold := Time.Elapsed
    cls

    lookDirection -> x := -sind (cam_rot -> y)
    lookDirection -> y := sind (cam_rot -> x)
    lookDirection -> z := cosd (cam_rot -> y)
    if lookDirection -> y not= 0 then
	lookDirection -> Normalize ()
    end if

    %lookDirection->print()
    %cam_position->print()
    %cam_rot->print()

    handleMouse ()
    handleKeyboard ()

    cube1 -> draw (angle, cam_position, cam_rot, brightblue)
    cube2 -> draw (-angle, cam_position, cam_rot, brightred)

    %var tempp : string(1)
    %getch(tempp)

    %angle += speed * deltaTime
    View.Update ()
    exit when not running
end loop

cube1 -> freeData ()
cube2 -> freeData ()
free cube1
free cube2
