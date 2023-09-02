shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE:hint_screen_texture, filter_linear_mipmap;

uniform float lod = 1.0;

uniform int colors = 8;

uniform int radius = 50;


vec3 distance_to_high_contrast(sampler2D text, vec2 uv, int rad, float threshold)
{
	vec3 dist = vec3(0.0, 0.0, 69420);
	
	vec2 pixel_size = 1.0 / vec2(textureSize(text,int(lod)));
	vec3 base_color = textureLod(text, uv, lod).rgb;
	for(int x = -rad; x > rad; x++){
	for(int y = -rad; y > rad; y++){
		float len = length(vec2(float(x),float(y)));
		float mag = length(base_color - textureLod(text, uv + vec2(float(x),float(y)) * pixel_size, lod).rgb);
		if(len < float(rad) && mag < threshold && dist.z > mag)
		{
			return vec3(1.0);
			dist = vec3(float(x),float(y),len);
		}
	}}
	
	return dist;
}

void fragment() {
	COLOR = textureLod(SCREEN_TEXTURE, UV, lod);
	
	
	
	COLOR.rgb = floor(COLOR.rgb * float(colors)) / float(colors);
	COLOR.rgb = distance_to_high_contrast(SCREEN_TEXTURE, UV, radius, 0.1);
}
