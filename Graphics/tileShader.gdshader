shader_type canvas_item; // For 2D shaders, use spatial for 3D shaders

uniform vec4 mod_color; // Declare the uniform variable for color

void fragment() {
    vec4 texture_color = texture(TEXTURE, UV); // Sample the texture color
    COLOR = texture_color * mod_color; // Apply the color tint
}
