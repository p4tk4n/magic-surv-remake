shader_type canvas_item;

uniform float health_percent : hint_range(0.0, 1.0) = 1.0;
uniform float flash_amount : hint_range(0.0, 1.0) = 0.0;
uniform vec4 vignette_color : source_color = vec4(0.6, 0.0, 0.0, 1.0);
uniform float max_intensity : hint_range(0.0, 1.0) = 0.85;
uniform float radius : hint_range(0.0, 1.0) = 0.4;
uniform float softness : hint_range(0.0, 1.0) = 0.5;
uniform float health_threshold : hint_range(0.0, 1.0) = 0.7;

void fragment() {
    vec2 uv = UV - vec2(0.5);
    float dist = length(uv);

    float hurt = 1.0 - smoothstep(0.0, health_threshold, health_percent);

    float edge = smoothstep(radius - softness, radius + softness, dist);

    float base_alpha = edge * hurt * max_intensity;
    float flash_alpha = edge * flash_amount * max_intensity;

    float final_alpha = max(base_alpha, flash_alpha);
    COLOR = vec4(vignette_color.rgb, final_alpha);
}