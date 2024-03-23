shader_type spatial;
uniform float heights[256];

void vertex() {
	float index = trunc(VERTEX.x);
	float x_offset = VERTEX.x - index - 0.25;
	VERTEX = vec3(0.5 * index + x_offset, VERTEX.y * heights[int(index)] * 100.0 / 255.0, VERTEX.z);
}

void fragment() {
	// Called for every pixel the material is visible on.
	//ALBEDO = COLOR.rgb;
	ALBEDO = vec3(0.0, 0.0, 1.0);
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
