shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 uv = UV;
	
	uv.x += sin((uv.x + TIME) - 0.5) * .07 * (1.0 - uv.y);
	
	uv.x -= .5;
	uv.x *= 1.3;
	uv.x += .5;
	
	
	if (uv.x > 1.0 || uv.x < 0.0){
		discard;
	}

	if (uv.y > 1.0 || uv.y < 0.0){
		discard;
	}
	
	vec4 color = texture(TEXTURE, uv);
	COLOR = color;
	
	
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
