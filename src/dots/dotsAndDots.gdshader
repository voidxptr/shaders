shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE:hint_screen_texture, filter_linear_mipmap;

group_uniforms TonalSelect;
uniform float limit_high:hint_range(0, 1, 0.1) = 0.5;
uniform float limit_low:hint_range(0,1,0.1) = 0.3;
uniform float lod:hint_range(0, 2, 0.1) = 1;

group_uniforms TonalSelectForDots;
uniform float limit_dots_high:hint_range(0, 1, 0.1) = 0.7;
uniform float limit_dots_low:hint_range(0,1,0.1) = 0.2;
uniform float lod_dots:hint_range(0, 2, 0.1) = 1;

group_uniforms Dots;
uniform float dot_freshhold:hint_range(0.0, 1.0, 0.001) = 0.9;

float get_value(vec3 c) {
	return (c.r + c.b + c.g) / 3.0;
}

int wang_hash(int s)
{
    int seed = (s ^ 61) ^ (s >> 16);
    seed *= 9;
    seed = seed ^ (seed >> 4);
    seed *= 0x27d4eb2d;
    seed = seed ^ (seed >> 15);
    return seed;
}

int random(int seed)
{
	return wang_hash(seed) / 2147483647;
}

float random_from_vec(ivec2 seed)
{
	return float(wang_hash(wang_hash(seed.x) * 3457 + wang_hash(seed.y) * 8455)) / 2147483647.0;
}


void fragment() {
	COLOR.rgb = vec3(0.0);
	
	float v = get_value(textureLod(SCREEN_TEXTURE, UV, lod).rgb);
	
	
	if( v > limit_low && v < limit_high && textureLod(SCREEN_TEXTURE, UV, lod).a == 1.0) {
		COLOR.rgb = vec3(1.0);
	}
	
	float v_dots = get_value(textureLod(SCREEN_TEXTURE, UV, lod_dots).rgb);
	
	if( v_dots > limit_dots_low && v_dots < limit_dots_high && textureLod(SCREEN_TEXTURE, UV, lod_dots).a == 1.0) {
		COLOR.rgb = random_from_vec(ivec2(FRAGCOORD.xy )) > dot_freshhold ? 1.0 - COLOR.rgb : COLOR.rgb;
	}
	
	COLOR.rgb = vec3(1.0) - COLOR.rgb;
	
//	COLOR.rgb = vec3(random_from_vec(ivec2(FRAGCOORD.xy)));
	
//	COLOR.rgb = vec3(get_value(texture(SCREEN_TEXTURE, UV).rgb));
}
