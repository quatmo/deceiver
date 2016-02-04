#pragma once

#include "data/entity.h"
#include "physics.h"
#include "ai.h"

namespace VI
{

struct Traceur : public Entity
{
	Traceur(const Vec3&, const Quat&, AI::Team);
};

struct Parkour : public ComponentType<Parkour>
{
	enum class State
	{
		Normal,
		Run,
		Mantle,
		WallRun,
	};

	enum class WallRunState
	{
		Left,
		Right,
		Forward,
		None,
	};

	FSM<State> fsm;
	Vec3 relative_wall_run_normal;
	WallRunState wall_run_state;
	Vec3 relative_support_pos;
	Ref<RigidBody> last_support;
	r32 last_support_time;
	r32 tile_spawn_timer;

	b8 wallrun(const Update&, RigidBody*, const Vec3&, const Vec3&);

	b8 try_jump(r32);
	b8 try_parkour(b8 = false);
	void set_run(b8);
	void awake();
	Vec3 head_pos();
	void head_to_object_space(Vec3*, Quat*);
	void footstep();
	b8 try_wall_run(WallRunState, const Vec3&);
	void wall_jump(r32, const Vec3&, const btRigidBody*);

	void update(const Update&);
};

}
