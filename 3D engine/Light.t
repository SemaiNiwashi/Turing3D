unit
class light
    import "Vector/vec3.t", "Vector/VectorCreator.t" %, "ColorManager.t"
    export _set, on, position, ambient, diffuse, specular, AttenuationConstant, AttenuationLinear, AttenuationQuadratic, freeData

    var on : boolean := false
    var position : ^vec3 := vc.getVec3 (0, 0, 0)
    %I am begrudgingly using 0-1 values for colors in this program, rather than 0-255.
    var ambient : ^vec3  := vc.getVec3(0.5, 0.5, 0.5)
    var diffuse : int := white %: ^vec3 := vc.getVec3(1.0, 1.0, 1.0)
    var specular : int := white %: ^vec3 := vc.getVec3(1.0, 1.0, 1.0)*/
    var AttenuationConstant : real := 1.0
    var AttenuationLinear : real := 0.01
    var AttenuationQuadratic : real := 0.0 %0.01f

    procedure _set (positionx, positiony, positionz : real)
	on := true
	position -> _set (positionx, positiony, positionz)
    end _set

    procedure freeData
	free position
	free ambient
	%free diffuse
	%free specular
    end freeData

end light
