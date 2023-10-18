
uniform mat4 projMat;

uniform vec2 texSizeInv;
uniform vec2 translation;

uniform vec2 aniOffset;

attribute vec2 position;
attribute vec2 texCoord;

varying vec2 v_texCoord;

const vec2 atAreaA = vec2(9.0*32.0, 12.0*32.0);
const float atAreaCX = 12.0*32.0;
const float atAreaCW = 4.0*32.0;

void main()
{
	vec2 tex = texCoord;
	lowp float pred;

	/* Type A autotiles shift horizontally */
	pred = float(tex.x <= atAreaA.x && tex.y <= atAreaA.y);
	tex.x += aniOffset.x * pred;

	/* Type C autotiles shift vertically */
	pred = float(tex.x >= atAreaCX && tex.x <= (atAreaCX+atAreaCW) && tex.y <= atAreaA.y);
	tex.y += aniOffset.y * pred;

	/* On Vulkan ANGLE on Windows, there is an issue with this shader. Tiles render slightly differently based on
	   position, giving a flickering effect when scrolling horizontally. This is most noticeable with the rightmost
	   row of pixels. Setting any of the following to highp will prevent the issue: projMat, translation, position.
	   I'm electing to add this extra step so as not to single out any uniforms/attributes. */
	highp vec4 highPrecisionPosition = vec4(position + translation, 0, 1);
	gl_Position = projMat * highPrecisionPosition;

	v_texCoord = tex * texSizeInv;
}
