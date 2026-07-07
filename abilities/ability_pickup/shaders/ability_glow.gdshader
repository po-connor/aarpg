shader_type canvas_item;

uniform float glow_size: hint_range(0.0, 20.0) = 8.0;
uniform vec4 glow_color: source_color = vec4(1.0, 0.85, 0.2, 1.0);
uniform float glow_intensity: hint_range(0.0, 3.0) = 1.2;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 original = texture(TEXTURE, UV);
	float alpha_sum = 0.0;
	vec2 texture_size = vec2(textureSize(TEXTURE, 0));
	vec2 pixel_size = TEXTURE_PIXEL_SIZE;
	
	int steps = 8;
	for (int x = -steps; x <= steps; x++) {
		for (int y = -steps; y <= steps; y++) {
			vec2 offset = vec2(float(x), float(y)) * pixel_size * glow_size / float(steps);
			float neighbor_alpha = texture(TEXTURE, UV + offset).a;
			float dist = length(vec2(float(x), float(y))) / float(steps);
			alpha_sum += neighbor_alpha * (1.0 - dist);
		}
	}
	float glow_alpha = clamp(alpha_sum / float(steps * 2 + 1) * float(steps * 2 + 1), 0.0, 1.0);
	vec4 glow = glow_color * glow_alpha * glow_intensity;
	COLOR = mix(glow, original, original.a);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
