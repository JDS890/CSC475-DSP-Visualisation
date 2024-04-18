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
uniform float spec_scales[5];

uniform int mode = 1;

varying flat int stem_index_int;
varying float heights[5];
varying float height_vary;


void vertex() {
	
	if (mode == 0)
	{
	
		float bin_index = trunc(VERTEX.x);
		float stem_index = trunc(-VERTEX.z);
		
		if (bin_index < bins_per_spec) {
			
			float height = bins[(int(stem_index) << 8) + int(bin_index)];
			
			if (height > -1.0) { // Make this height > 0.0 to improve performance
				float x_offset = VERTEX.x - bin_index - 0.25; // 0.0 or 0.5
				float z_offset = VERTEX.z + stem_index + 0.25; // 0.0 or 0.5
				
				VERTEX = vec3(
					(0.5 * bin_index + x_offset * bin_width) * (256.0 / bins_per_spec),
					VERTEX.y * height * spec_scale * spec_scales[int(stem_index)],
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


	
	else
	{	
		// Note to self: these aren't interopolated in fragment shader since
		// they all belong to the same connected cube mesh
		float bin_index = trunc(VERTEX.x);
		float stem_index = trunc(-VERTEX.z);
		stem_index_int = int(stem_index);
		int bin_index_int = int(bin_index);
		
		if (bin_index < bins_per_spec) {
			
			heights[0] = bins[bin_index_int] * spec_scale;
			for (int i = 1; i <= stem_index_int; i++) {
				heights[i] = heights[i-1] + bins[(i << 8) + bin_index_int] * spec_scale * spec_scales[int(stem_index)];
			}
			
			float x_offset = VERTEX.x - bin_index - 0.25; // 0.0 or 0.5
			float z_offset = VERTEX.z + stem_index + 0.25; // 0.0 or 0.5
			
			VERTEX = vec3(
				(0.5 * bin_index + x_offset * bin_width) * (256.0 / bins_per_spec),
				heights[stem_index_int] * VERTEX.y * spec_scales[int(stem_index)],
				//VERTEX.y * spec_scale,
				-0.5 * spec_separation * stem_index + z_offset
			);
		
		}
		else {
			VERTEX = vec3(0.0);
		}
	}
	height_vary = VERTEX.y;



}

void fragment() {
	// Called for every pixel the material is visible on.
	
	if (mode == 0)
	{
		//ALBEDO = COLOR.rgb;
		//ALBEDO = spec_colors[int(stem_index)].rgb;
		//ALPHA = spec_colors[int(stem_index)].a;
		ALBEDO = COLOR.rgb;
		//ALPHA = COLOR.a;
	}
	
	else
	{
		//float height = (INV_VIEW_MATRIX * vec4(VERTEX, 1.0)).y;
		for (int i = 0; i <= stem_index_int; i++) {
			if (height_vary <= heights[i]) {
				ALBEDO = spec_colors[i].rgb;
				break;
			}
		}
		//if (height_vary <= )
		
		//if (height_vary < heights[0]) {
			//ALBEDO = vec3(1.0);
			//
		//} else {
			//ALBEDO = vec3(1.0, 0.0, 0.0);
		//}
		
		//if (VERTEX.y < 2.0) {
			//ALBEDO = spec_colors[0].rgb;
		//}
	}
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
