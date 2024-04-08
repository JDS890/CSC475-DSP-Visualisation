shader_type spatial;

// ToDo
// Create combined spectrogram (don't need extra data, but need extra mesh)
// Create total, difference spectrograms (both need extra data and mesh)

// Size = 256 bins * 5 spec = 1280
uniform float bins[1280];
uniform float bins_per_spec : hint_range(1, 256) = 100;
uniform float spec_scale : hint_range(0.01, 100.0) = 1.0;
uniform float bin_width : hint_range(0.1, 1.0) = 0.5;
uniform float spec_separation : hint_range(0.0, 10.0) = 1.0;
uniform vec4 spec_colors[5]: source_color;


void vertex() {
	
	float bin_index = trunc(VERTEX.x);
	float stem_index = trunc(-VERTEX.z);
	
	if (bin_index < bins_per_spec) {
		
		float height = bins[(int(stem_index) << 8) + int(bin_index)];
		
		if (height > -1.0) { // Make this height > 0.0 to improve performance
			float x_offset = VERTEX.x - bin_index - 0.25; // 0.0 or 0.5
			float z_offset = VERTEX.z + stem_index + 0.25; // 0.0 or 0.5
			
			VERTEX = vec3(
				(0.5 * bin_index + x_offset * bin_width) * (256.0 / bins_per_spec),
				VERTEX.y * height * spec_scale,
				//VERTEX.y * spec_scale,
				-0.5 * spec_separation * stem_index + z_offset
			);
			
			COLOR = spec_colors[int(stem_index)];
		}
		else {
			VERTEX = vec3(0.0);
		}
	}
	else {
		VERTEX = vec3(0.0);
	}
}

void fragment() {
	// Called for every pixel the material is visible on.
	//ALBEDO = COLOR.rgb;
	//ALBEDO = spec_colors[int(stem_index)].rgb;
	//ALPHA = spec_colors[int(stem_index)].a;
	ALBEDO = COLOR.rgb;
	//ALPHA = COLOR.a;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
