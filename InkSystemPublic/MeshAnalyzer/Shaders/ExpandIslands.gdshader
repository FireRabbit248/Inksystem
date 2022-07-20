shader_type canvas_item;

void fragment() {
	
	vec2 offset = vec2(TEXTURE_PIXEL_SIZE.x, 0.0);
	
	vec4 p0 = texture(TEXTURE, UV);
	vec4 pointList[8];
	if (p0 == vec4(0,0,0,1)) {
		pointList[0] = texture(TEXTURE, UV + offset);
		pointList[1] = texture(TEXTURE, UV - offset);
		pointList[2] = texture(TEXTURE, UV + offset.yx);
		pointList[3] = texture(TEXTURE, UV - offset.yx);
		pointList[4] = texture(TEXTURE, UV - vec2(offset.x, offset.x));
		pointList[5] = texture(TEXTURE, UV - vec2(offset.x, -offset.x));
		pointList[6] = texture(TEXTURE, UV - vec2(-offset.x, offset.x));
		pointList[7] = texture(TEXTURE, UV - vec2(-offset.x, -offset.x));
		
		
		int number = 0;
		vec4 sum = vec4(0);
		
		for (int i = 0; i < 8; i++)
		{
			if (pointList[i] != vec4(0,0,0,1)) {
				number += 1;
				sum += pointList[i];
			}
		}
		
		COLOR = sum / float(number);
		
	} else {
		COLOR = p0;
	}
}