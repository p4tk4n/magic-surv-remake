shader_type canvas_item;

uniform vec4 outline_color: source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float outline_width: hint_range(0.0, 10.0) = 2.0;
uniform bool enabled = false;

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);

    if (enabled && tex_color.a < 0.5) {
        vec2 pixel_size = outline_width / vec2(textureSize(TEXTURE, 0));
        float outline_alpha = 0.0;

        for (float x = -1.0; x <= 1.0; x += 1.0) {
            for (float y = -1.0; y <= 1.0; y += 1.0) {
                if (x == 0.0 && y == 0.0) continue;
                vec2 offset = vec2(x, y) * pixel_size;
                outline_alpha = max(outline_alpha, texture(TEXTURE, UV + offset).a);
            }
        }

        if (outline_alpha > 0.0) {
            COLOR = vec4(outline_color.rgb, outline_alpha);
        } else {
            COLOR = tex_color;
        }
    } else {
        COLOR = tex_color;
    }
}