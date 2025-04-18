unit
module vc %vector creator
    import "vec2h.t", "vec2ih.t", "vec3h.t", "vec3ih.t", "vec4h.t"
    export all
    function getVec2i (xi, yi : int) : ^vec2ih
	var temp : ^vec2ih
	new temp
	temp -> _set (xi, yi)
	result temp
    end getVec2i
    
    function getVec2 (xi, yi : real) : ^vec2h
	var temp : ^vec2h
	new temp
	temp -> _set (xi, yi)
	result temp
    end getVec2
    
    function getVec3i (xi, yi, zi : int) : ^vec3ih
	var temp : ^vec3ih
	new temp
	temp -> _set (xi, yi, zi)
	result temp
    end getVec3i
    
    function getVec3 (xi, yi, zi : real) : ^vec3h
	var temp : ^vec3h
	new temp
	temp -> _set (xi, yi, zi)
	result temp
    end getVec3
    
    function getVec4 (xi, yi, zi, wi : real) : ^vec4h
	var temp : ^vec4h
	new temp
	temp -> _set (xi, yi, zi, wi)
	result temp
    end getVec4
end vc

