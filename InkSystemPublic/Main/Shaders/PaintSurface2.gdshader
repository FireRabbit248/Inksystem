shader_type spatial;
render_mode cull_disabled;

uniform sampler2D paint_mask : hint_albedo;
uniform vec3 pos;
uniform sampler2D tex1 : hint_albedo;



uniform float size = 0.002;

void vertex() {
	VERTEX += NORMAL * size;
}
void fragment() {
	vec4 color = texture(paint_mask, UV);
	vec4 inkColor;
	
	float ink1 = step(0.5, color.r);
	float ink2 = step(0.5, color.g);
	inkColor.rgb = (ink1 * texture(tex1, UV)).rgb;
	if (inkColor.rgb == vec3(0.0)) {
		discard;
	}
	ALBEDO = length(color.rgb) / 1.5* inkColor.rgb;
	
	
	EMISSION = ALBEDO * 0.5;
	DEPTH = FRAGCOORD.z - 0.00001;
}