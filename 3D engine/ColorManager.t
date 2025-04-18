unit
module clrMngr
    export getClr, getClr255, getKnownClr, getKnownClr255, setTolerance, currentBiggestClr
    var colorLimit : int := cdMaxNumColours
    var colorsStart : int := 16
    var currentBiggestClr : int := 255
    var nextClr : int := colorsStart
    var toleranceOff : int := 20 %/255
    %I've found a tolerance of 20 to be almost infinite in my test with clrManagerTester.t

    procedure setTolerance (newTol : int)
	toleranceOff := newTol
    end setTolerance
    
    function getKnownClr (r, g, b : real, prev : int) : int
	%if color is still at previous location, return it
	if prev >= 0 then
	    var rc, gc, bc : real
	    RGB.GetColor (prev, rc, gc, bc)
	    if abs (r - rc) < toleranceOff / 255 and abs (g - gc) < toleranceOff / 255 and abs (b - bc) < toleranceOff / 255 then
		result prev
	    end if
	end if

	%else if color already exists to within a certain tolerance, give that.
	for i : 0 .. currentBiggestClr
	    var rc, gc, bc : real
	    RGB.GetColor (i, rc, gc, bc)
	    if abs (r - rc) < toleranceOff / 255 and abs (g - gc) < toleranceOff / 255 and abs (b - bc) < toleranceOff / 255 then
		result i
	    end if
	end for

	%else, create it
	if nextClr > currentBiggestClr then
	    nextClr := RGB.AddColor (r, g, b)
	    if nextClr = currentBiggestClr + 1 then
		currentBiggestClr += 1
	    else
		%Disable this error if you want. It should never happen, technically.
		Error.Halt ("Color generation has gone wrong")
	    end if
	else
	    RGB.SetColor (nextClr, r, g, b)
	end if

	var temp : int := nextClr
	nextClr += 1
	if nextClr >= cdMaxNumColours then
	    nextClr := colorsStart
	end if
	result temp
    end getKnownClr

    function getClr (r, g, b : real) : int
	result getKnownClr (r, g, b, -1)
    end getClr

    function getClr255 (r, g, b : real) : int
	result getClr (r / 255, g / 255, b / 255)
    end getClr255

    function getKnownClr255 (r, g, b : real, prev : int) : int
	result getKnownClr (r / 255, g / 255, b / 255, prev)
    end getKnownClr255
end clrMngr
