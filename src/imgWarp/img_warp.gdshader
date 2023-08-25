shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE:hint_screen_texture;


uniform sampler2D warp_img:hint_default_black;

group_uniforms img_context;
uniform int x_index:hint_range(0, 3, 1) = 0;
uniform int y_index:hint_range(0, 3, 1) = 1;
uniform int mix_by_color_index:hint_range(0, 3, 1) = 2;

group_uniforms warp_settings;
uniform float warp_scale:hint_range(0.0, 100.0, 0.1) = 45.0;
uniform bool inver_warp = false;

uniform bool warp_by_pixel = true;

group_uniforms color_mix;
uniform bool enable_mix = false;
uniform float mix_value:hint_range(0.0, 1.0, 0.01) = 0.15;
uniform bool mix_by_color = true;


void fragment() {
	
	vec4 img = texture(warp_img, UV);
	
	vec2 warp = vec2(img[x_index], img[y_index]);
	
	if(warp_by_pixel)
	{
		warp *= SCREEN_PIXEL_SIZE;
	}
	if(inver_warp)
	{
		warp *= -1.0;
	}
	
	warp *= warp_scale;
	
	COLOR = texture(SCREEN_TEXTURE, UV + warp);
	
	if(enable_mix)
	{
		float v = mix_value;
		
		if(mix_by_color)
		{
			v *= img[mix_by_color_index];
		}
		
		COLOR = mix(COLOR, img, v);
	}
	
}
