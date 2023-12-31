shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE:hint_screen_texture,  filter_linear;

group_uniforms masking_color;
uniform bool mask_by_col = true;
uniform vec3 mask_by_col_color:source_color;
uniform bool mask_by_col_inv = false;

group_uniforms masking_sat;
uniform bool mask_by_sat = false;
uniform float mask_by_sat_min:hint_range(0.0, 1.0, 0.01) = 0.6;
uniform float mask_by_sat_max:hint_range(0.0, 10.0, 0.1) = 6.9;
uniform bool mask_by_sat_inv = false;

group_uniforms masking_val;
uniform bool mask_by_val = false;
uniform float mask_by_val_min:hint_range(0.0, 1.0, 0.01) = 0.6;
uniform float mask_by_val_max:hint_range(0.0, 10.0, 0.1) = 6.9;
uniform bool mask_by_val_inv = false;

group_uniforms mask_color_overlay;
uniform bool mask_color_overlay = false;
uniform vec3 mask_color_color:source_color;

group_uniforms debug;
uniform bool debug_visual_mask = false;

float sum(vec3 col)
{
	return col.x + col.y + + col.z;
}

float average(vec3 col)
{
	return sum(col) / 3.0;
}

float saturation(vec3 col)
{
	float avg = average(col);
	
	avg = sum(abs(col - vec3(avg)));
	
	return avg;
}

vec4 box_blur(sampler2D text, vec2 uv, vec2 pixel_size)
{
	vec4 sum = vec4(0.0);
	for(int x = -1; x <= 1; x++)
	{
		for(int y = -1; y <= 1; y++)
		{
			sum += texture(text, uv + pixel_size * vec2(float(x), float(y)));
		}
	}
	
	sum /= 9.0;
	
	return sum;
}

void fragment() {
	
	vec4 tex = texture(SCREEN_TEXTURE,UV);
	vec4 texblured = box_blur(SCREEN_TEXTURE, UV, SCREEN_PIXEL_SIZE);
	
	float mask = 1.0;
	if(mask_by_sat)
	{
		float sat = saturation(texblured.rgb);
		
		sat = clamp((sat * mask_by_sat_max) - (mask_by_sat_min * mask_by_sat_max), 0.0, 1.0);

		if(mask_by_sat_inv) {sat = 1.0 - sat;}
		
		mask *= clamp(sat, 0.0, 1.0);
	}
	
	if(mask_by_val)
	{
		float val = average(texblured.rgb);
		
		val = clamp((val * mask_by_val_max) - (mask_by_val_min * mask_by_val_max), 0.0, 1.0);

		if(mask_by_val_inv) {val = 1.0 - val;}
		
		mask *= clamp(val, 0.0, 1.0);
	}
	
	if(mask_by_col)
	{
		float col = clamp(length(mask_by_col_color - texblured.rgb), 0.0, 1.0);
		
		if(mask_by_col_inv) {col = 1.0 - col;}
		
		mask *= clamp(col, 0.0, 1.0);
	}
	
	COLOR.rgb = mix(vec3(average(tex.rgb)), tex.rgb, mask);
	
	if(mask_color_overlay)
	{
		COLOR.rgb = mix(vec3(average(tex.rgb)), average(tex.rgb) * mask_color_color, mask);
	}
	
//	COLOR.rgb = normalize(texblured.rgb);
	
	if(debug_visual_mask) { COLOR.rgb = vec3(mask); }
}
