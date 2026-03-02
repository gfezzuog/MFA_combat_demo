shader_type canvas_item;

uniform float highlight_strength : hint_range(0.0, 1.0) = 0.0;
uniform float blink_speed = 4.0; // velocità lampeggio

void fragment() {
    vec4 tex = texture(TEXTURE, UV);

    float blink = (sin(TIME * blink_speed) * 0.5 + 0.5);
    
    float final_strength = highlight_strength * blink;

    vec3 highlight = vec3(1.0, 0.9, 0.6);

    tex.rgb += highlight * final_strength * 0.5;

    COLOR = tex;
}