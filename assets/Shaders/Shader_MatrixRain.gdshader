shader_type canvas_item;

uniform float speed : hint_range(0.1, 2.0) = 0.6;
uniform float density : hint_range(0.5, 4.0) = 1.5;
uniform float trail_length : hint_range(0.1, 1.0) = 0.6;
uniform vec4 head_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform vec4 trail_color : source_color = vec4(0.0, 1.0, 0.0, 1.0);
uniform sampler2D glyph_texture;
uniform float glyph_count_x = 16.0; // how many columns in the atlas
uniform float glyph_count_y = 16.0; // how many rows in the atlas

float rand(vec2 co) {
	return fract(sin(dot(co.xy, vec2(12.9898,78.233))) * 43758.5453);
}

void fragment() {
	vec2 uv = UV * vec2(density * 40.0, 40.0);
	vec2 grid = floor(uv);
	vec2 cell = fract(uv);
	
	float t = TIME * speed;
	float col_seed = rand(vec2(grid.x, 0.0));
	float drop_pos = fract(t + col_seed);

	// ❗ Reverse the direction logic
	// Instead of the trail being below, now it's above the head
	float diff = mod(drop_pos * 40.0 - grid.y, 40.0);
	float fade = clamp(1.0 - diff * trail_length, 0.0, 1.0);

	// Random flicker
	float flicker = step(0.97, rand(grid + floor(TIME * 5.0)));
	float brightness = fade + flicker * 0.3;

	vec4 color = mix(trail_color, head_color, smoothstep(0.8, 1.0, fade));
	color.rgb *= brightness;
	
	// Random glyph index per cell
	float glyph_index = floor(rand(grid) * (glyph_count_x * glyph_count_y));
	vec2 glyph_uv = vec2(
		mod(glyph_index, glyph_count_x),
		floor(glyph_index / glyph_count_x)
	) / vec2(glyph_count_x, glyph_count_y);

	// Inside the glyph cell
	glyph_uv += cell / vec2(glyph_count_x, glyph_count_y);

	// Sample glyph texture (white on black)
	float glyph_sample = texture(glyph_texture, glyph_uv).r;

	// Blend head and trail colors
	color.rgb *= brightness * glyph_sample;

	COLOR = color;
}
