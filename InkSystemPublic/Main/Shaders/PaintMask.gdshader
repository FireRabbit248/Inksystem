shader_type canvas_item;

uniform vec3 pos = vec3(-1,-1,-1);
uniform float radius = 1.0;
uniform float width = 0.5;
uniform vec4 brushColor : hint_color = vec4(1,0,0,1);


void fragment() {
	vec4 color = texture(TEXTURE, UV);
	
	COLOR = color;
	if (length(color) > 0.01) {
		float var = distance(color.xyz, pos);
		
		var /= radius;
		
		var = smoothstep(1.0 - width, 1.0, var);
		var = 1.0 - var;
		
		COLOR = brushColor;
		COLOR.a = var;
	} else {
		COLOR = vec4(1,0,0,1);
	}
}