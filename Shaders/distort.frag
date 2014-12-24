uniform sampler2D my_color_texture;
varying vec2 texCoord;
uniform float amount;
uniform float time;

void main() {
	vec2 newTexCoord = texCoord;
	for (int i = 0; i < 10; i++) {
		newTexCoord.x = newTexCoord.x + sin(newTexCoord.x*70.0*amount)*sin(newTexCoord.y*30.0*cos(time*.004))*amount*0.005*cos(time*.003);
		newTexCoord.y = newTexCoord.y + cos(newTexCoord.y*60.0*sin(time*.005))*sin(newTexCoord.x*40.0*amount)*amount*0.005*sin(time*.002);
	}
	gl_FragColor = texture2D(my_color_texture,newTexCoord);
	gl_FragColor.w *= 0.999*amount;
}
