shader_type spatial;
render_mode unshaded, cull_disabled;

void vertex() {
	COLOR.rgb = VERTEX;
	VERTEX = vec3(vec2(1.0) - UV, 0.0);
}

void fragment() {
	vec4 color = COLOR;
	ALBEDO = color.rgb;
}