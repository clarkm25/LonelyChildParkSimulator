shader_type spatial;
render_mode unshaded, cull_front, depth_draw_always;

instance uniform float thickness = 0;
uniform vec4 outline_color : source_color = vec4(1.0);

void vertex() {
	VERTEX += NORMAL * thickness;
}

void fragment() {
	ALBEDO = outline_color.rgb;
	if (outline_color.a < 1.0) {
		ALPHA = outline_color.a;
	}
}