//mesh
shader_type spatial;
uniform bool flash = false;
uniform float amount = 1.0;
uniform vec3 color = vec3(1,1,1);
uniform sampler2D texture_map : hint_albedo;

void fragment(){
	ALBEDO = texture(texture_map,UV).rgb;
	if(flash){
		EMISSION = color*amount;
	}
}