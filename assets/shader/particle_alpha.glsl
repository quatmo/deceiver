#ifdef VERTEX

layout(location = 0) in vec3 in_position;
layout(location = 1) in vec4 in_velocity;
layout(location = 2) in vec2 in_uv;
layout(location = 3) in float in_birth;
layout(location = 4) in vec4 in_param;

uniform mat4 mvp;
uniform mat4 p;
uniform float time;
uniform vec2 viewport_scale;
uniform float lifetime;
uniform float fade_in;
uniform vec3 gravity;
uniform vec4 diffuse_color;

// in_param
// x = start rotation
// y = start size
// z = end size
// w = unused

out float alpha;

void main()
{
	float dt = time - in_birth;

	vec3 world_position = in_position + (in_velocity.xyz * dt) + (0.5 * dt * dt * gravity);

	vec4 projected = mvp * vec4(world_position, 1);

	mat2 rotation;
	{
		float angle = in_param.x + in_velocity.w * dt;
		float c = cos(angle);
		float s = sin(angle);
		rotation = mat2(c, -s, s, c);
	}

	float t = dt / lifetime;
	alpha = diffuse_color.a * (dt < fade_in ? max(0.0, dt / fade_in) : 1.0) * (1.0f - t);

	float size = in_param.y + (in_param.z - in_param.y) * t;
	projected.xy += rotation * ((in_uv * 2.0) - 1.0) * size * p[1][1] * viewport_scale;

	gl_Position = projected;
}

#else

in float alpha;
out vec4 out_color;
uniform vec4 diffuse_color;

void main()
{
	out_color = vec4(diffuse_color.rgb, alpha);
}

#endif
