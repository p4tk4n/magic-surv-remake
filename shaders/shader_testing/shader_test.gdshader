shader_type canvas_item;

uniform vec4 flash_color: source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float zoom = 1.0;
uniform vec2 offset = vec2(0.0, 0.0);

uniform bool flipped_h = false;
uniform bool flipped_v = false;

uniform bool mirrored_h = false;

uniform float discard_percent: hint_range(0.0, 1.0, 0.01) = 0.0;

uniform float crop_size: hint_range(0.0, 0.5, 0.01) = .25;

uniform bool is_waving = false;
uniform float scale_x = 1.0;
uniform float scale_y = 1.0;
uniform float offset_x = 0.0;
uniform float offset_y = 0.0;
uniform float frequency = 1.0;

void vertex() {

}

void fragment() {
	vec2 centered_uv = (UV - .5) * 2.0;
	vec2 uv = centered_uv * zoom + offset;
	uv = (uv / 2.0) + .5;
	
	if (flipped_h) {
		uv.x = 1.0 - uv.x;
	}
	
	if (flipped_v) {
		uv.y = 1.0 - uv.y;
	}
	
	if (mirrored_h) {
		if (uv.y > .5){
			uv.y = 1.0 - uv.y;
		}
	}
	
	if (uv.x < discard_percent){
		discard;
	}
	
	if (uv.x < crop_size || 1.0 - uv.x < crop_size || uv.y < crop_size || 1.0 - uv.y < crop_size){
		discard;
	}
	
	//if (1.0 - uv.y > uv.x - 0.01 && 1.0 - uv.y < uv.x + 0.01){
		//discard;
	//}
	if (is_waving)
	{float left = (uv.y - offset_y) / scale_y;
	float right = sin((uv.x - offset_x + (TIME * frequency))/scale_x);
	
	if (left * .9 < right){
		discard;
	}}
		
	vec4 color = texture(TEXTURE, uv);
	
	
	
	COLOR = color;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
