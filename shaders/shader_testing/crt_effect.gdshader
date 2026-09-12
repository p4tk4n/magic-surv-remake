shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 uv = UV;
	
	COLOR = texture(TEXTURE, UV);
	
	float crt = sin((uv.y + (TIME / 40.0)) * 200.0) / 20.0;
	float crt2 = sin((uv.y + (TIME / 35.0)) * 100.0) / 20.0;
	COLOR.rgb += vec3(crt) + vec3(crt2);
	
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
