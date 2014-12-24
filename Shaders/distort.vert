varying vec2 texCoord;
void main() {
	gl_Position = ftransform();
	gl_FrontColor.xyzw = gl_Color.xyzw;
	texCoord = vec2(gl_MultiTexCoord0);
}
