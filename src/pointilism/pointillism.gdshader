shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE:hint_screen_texture, filter_linear_mipmap;

uniform float lod = 1.0;

uniform int colors = 8;



void fragment() {
	COLOR = textureLod(SCREEN_TEXTURE, UV, lod);
	
	COLOR.rgb = floor(COLOR.rgb * float(colors)) / float(colors);
	
}
