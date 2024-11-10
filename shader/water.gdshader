shader_type canvas_item;

uniform sampler2D screen_texture: hint_screen_texture;
uniform sampler2D noise_texture: filter_nearest, repeat_enable;

uniform float distortion = 0.01;

void vertex() {
	
}

void fragment() {
	vec2 noise = 2.0 * texture(noise_texture, UV).rg - vec2(1.0);
	COLOR = texture(TEXTURE, UV);
	COLOR*=texture(screen_texture, SCREEN_UV + noise * distortion);
}

