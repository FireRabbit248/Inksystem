shader_type spatial;
//render_mode unshaded;

uniform sampler2D albedo_tex : hint_albedo;
uniform vec3 pos;
uniform vec4 color1 : hint_color = vec4(1,0,0,1);
uniform vec4 color2 : hint_color = vec4(0,1,0,1);
uniform sampler2D normal_map : hint_normal;
uniform float roughness : hint_range(0,1) = 0.6;
uniform float normalmap_depth : hint_range(0,1) = 0.2;


uniform float size = 0.002;

void vertex() {
	VERTEX += NORMAL * size;
}
void fragment() {
	vec4 color = texture(albedo_tex, UV);
	vec4 inkColor;
	
	float ink1 = step(0.5, color.r);
	float ink2 = step(0.5, color.g);
	inkColor.rgb = (ink1 * color1 + ink2 * color2).rgb;
	if (inkColor.rgb == vec3(0,0,0)) {
		discard;
	}
	ALBEDO = length(color.rgb) / 1.5* inkColor.rgb;
	
	
	EMISSION = ALBEDO * 0.5;
	DEPTH = FRAGCOORD.z - 0.00001;
	NORMALMAP = texture(normal_map,UV).rgb;
	NORMALMAP_DEPTH = normalmap_depth;
	ROUGHNESS = roughness;
}