// 2D water shader done following a video tutorial by PlayWithFurcifer
// YouTube video: https://www.youtube.com/watch?v=eU-F-xuEo7s
// All credit goes to Fucifer: https://x.com/TweetFurcifer

// Some minor hacks applied post v4 update
// Adding additional comments so this can be implemented by beginners (incl. me)

// Before Pasting this code:
// 1. First create a new sprite. Any sprite will do. Dragging a default "icon.svg" is
// not a must but strongly advised.
// 2. Select the sprite. Under Inspector -> Material add a New ShaderMaterial;
// 3. Select the material (the white BALL). Shader -> New Shader, Options:
// Type: Shader; Mode: Canvas Item, Template: Empty; Path: whatever-you-want
// 4. Paste this code in the shader editor
// 5. Under shader parameters add noise and noise2,
// make sure to set them to seamless. I use FastNoise, you can choose hichever
// noise you wish. Experimentation is part of the fun :)

shader_type canvas_item;

// We must retrieve this post godot3 as SCREEN_TEXTURE global value was removed
uniform sampler2D screen_texture : hint_screen_texture, filter_nearest;

// Layer 1 - noise to waves
// Remember to add noise pattern manually
uniform sampler2D noise : repeat_enable;
uniform vec2 scroll = vec2(0.05, 0.05);

//Layer 2 - noise to waves, but in a different direction
// Another noise pattern here
uniform sampler2D noise2 : repeat_enable;
uniform vec2 scroll2 = vec2(-0.05, -0.05); //this sets them to different dir

// the default value needs to be 10x lower than in original tutorial to work
// this may be according to shader size (the larger the shader, the larger the value)
uniform float distortion_streingth: hint_range(-1, 1) = 0.02;

//Layer 3 - allows us to set the color of water
uniform vec4 tone_color : source_color;

//Layer 4 - highlights
uniform vec4 top_color : source_color;
uniform float light_start : hint_range(0.0, 1.0) = 0.275;
uniform float light_end : hint_range(0.0, 1.0) = 0.4;


void fragment() {
	//// Called for every pixel the material is visible on.
	float depth = texture(noise, UV + scroll * TIME).r
		* texture(noise2, UV + scroll2 * TIME).r;
	vec4 screen_col = texture(screen_texture, SCREEN_UV
		+ distortion_streingth * vec2(depth));
	vec4 top_light = smoothstep(light_start, light_end, depth) * top_color;
	COLOR = screen_col * tone_color + top_light;
	COLOR.a = 1.0;
}
