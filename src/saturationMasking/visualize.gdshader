shader_type canvas_item;

uniform sampler2D SCREEEN_TEXTURE: hint_screen_texture;
uniform float mix_val:hint_range(0.0, 1.0, 0.05) = 0.8;

float avg(vec3 a)
{
	return (a.r + a.b + a.g) /3.0;
}

float get_saturation(vec3 color)
{
	float a = length(color - vec3(avg(color)));
	a = pow(length(color), 2.0) * a;
	return a;
}

float sampler_sat(sampler2D samp, vec2 uv)
{
	return get_saturation(texture(samp, uv).rgb);
}

float blured_sampler_sat(sampler2D samp, vec2 uv)
{
	vec2 pixel_size = 1.0 / vec2(textureSize(samp, 0));
	
	float a = 0.0;
	float c = 0.0;
	
	for(int x = -2; x < 2; ++x)
	{
		for(int y = -2; y < 2; ++y)
		{
			a += sampler_sat(samp, uv + pixel_size * vec2(float(x), float(y)));
			++c;
		}
	}
	
	return a;
}

void fragment() {
	COLOR.rgb = texture(SCREEEN_TEXTURE, UV).rgb;
	
	COLOR.rgb = mix(vec3(sampler_sat(SCREEEN_TEXTURE, UV)), COLOR.rgb, mix_val);
	
}
