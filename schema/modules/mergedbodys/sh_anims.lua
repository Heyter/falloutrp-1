nut.anim.fallout_male = {
	normal = {
		idle 					=	{ACT_IDLE, ACT_IDLE_ANGRY_SMG1},
		idle_crouch 			=	{ACT_COVER_LOW, ACT_COVER_LOW},
		walk 					=	{ACT_WALK, ACT_WALK_AIM_RIFLE_STIMULATED},
		walk_crouch 			=	{ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		run 					=	{"run_all", ACT_RUN_AIM_RIFLE_STIMULATED},

		idle_panicked 			=	{"crouchIdle_panicked4", "Crouch_Idle_RPG"},
		run_panicked 			=	{"crouchRUNALL1", "crouchRUNHOLDINGALL1"},
		walk_panicked 			=	{"walk_panicked_all", "walk_panicked_all"},
		walk_panicked_crouch 	=	{ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		idle_panicked_crouch 	=	{ACT_COVER_LOW, ACT_COVER_LOW},

		idle_depressed 			=	{"LineIdle02", ACT_IDLE_ANGRY_SMG1},
		run_depressed 			=	{"run_all", ACT_RUN_AIM_RIFLE_STIMULATED},
		walk_depressed 			=	{"pace_all", ACT_WALK_AIM_RIFLE_STIMULATED},
		walk_depressed_crouch 	=	{ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		idle_depressed_crouch 	=	{ACT_COVER_LOW, ACT_COVER_LOW}

	},
	pistol = {
		idle 					= 	{ACT_IDLE, ACT_IDLE_ANGRY_SMG1},
		idle_crouch 			= 	{ACT_COVER_LOW, "crouch_aim_smg1"},
		walk 					= 	{ACT_WALK, ACT_WALK_AIM_RIFLE_STIMULATED},
		walk_crouch 			= 	{ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		run 					= 	{ACT_RUN, ACT_RUN_AIM_RIFLE_STIMULATED},
		attack 					= 	ACT_GESTURE_RANGE_ATTACK_PISTOL,
		reload 					= 	ACT_GESTURE_RELOAD_SMG1,

		idle_panicked 			= 	{"crouchIdle_panicked4", "crouch_aim_smg1"},
		run_panicked 			= 	{"crouch_run_holding_RPG_all", "crouchRUNHOLDINGALL1"},
		walk_panicked 			= 	{"walk_panicked_all", "Crouch_walk_aiming_all"},
		walk_panicked_crouch 	= 	{ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		idle_panicked_crouch 	= 	{ACT_COVER_LOW, ACT_COVER_LOW},

		idle_depressed 			= 	{ACT_IDLE, ACT_IDLE_ANGRY_SMG1},	
		run_depressed 			= 	{ACT_RUN, ACT_RUN_AIM_RIFLE_STIMULATED},
		walk_depressed 			= 	{ACT_WALK, ACT_WALK_AIM_RIFLE_STIMULATED},
		walk_depressed_crouch 	=	{ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		idle_depressed_crouch 	=	{ACT_COVER_LOW, "crouch_aim_smg1"}
	},
	ar2 = {
		idle 					= 	{ACT_IDLE_SHOTGUN_RELAXED, ACT_IDLE_ANGRY_RPG},
		idle_crouch 			= 	{ACT_COVER_LOW_RPG,  "crouch_aim_smg1"},
		walk 					= 	{ACT_WALK_RPG,  ACT_WALK_AIM_RIFLE_STIMULATED},
		walk_crouch 			= 	{ACT_WALK_CROUCH, "Crouch_walk_aiming_all"},
		run 					= 	{ACT_RUN, ACT_RUN_AIM_RIFLE_STIMULATED},
		attack 					= 	ACT_GESTURE_RANGE_ATTACK_SNIPER_RIFLE,
		reload 					= 	ACT_GESTURE_RELOAD_SMG1,

		idle_panicked 			= 	{"crouchIdle_panicked4", "crouch_aim_smg1"},
		run_panicked 			= 	{"crouch_run_holding_RPG_all", "crouchRUNHOLDINGALL1"},
		walk_panicked 			= 	{"walk_panicked_all", "Crouch_walk_aiming_all"},
		walk_panicked_crouch 	= 	{ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		idle_panicked_crouch 	= 	{ACT_COVER_LOW, ACT_COVER_LOW},

		idle_depressed 			= 	{ACT_IDLE, ACT_IDLE_ANGRY_SMG1},	
		run_depressed 			= 	{ACT_RUN, ACT_RUN_AIM_RIFLE_STIMULATED},
		walk_depressed 			= 	{ACT_WALK, ACT_WALK_AIM_RIFLE_STIMULATED},
		walk_depressed_crouch 	=	{ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		idle_depressed_crouch 	=	{ACT_COVER_LOW, "crouch_aim_smg1"}
	},
	smg = {
		idle 					= 	{ACT_IDLE_SMG1_RELAXED, ACT_IDLE_ANGRY_SMG1},
		idle_crouch 			= 	{ACT_COVER_LOW, "crouch_aim_smg1"},
		walk 					= 	{ACT_WALK_RIFLE_RELAXED, ACT_WALK_AIM_RIFLE_STIMULATED},
		walk_crouch 			= 	{ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		run 					= 	{ACT_RUN_RIFLE_RELAXED, ACT_RUN_AIM_RIFLE_STIMULATED},
		attack 					= 	ACT_GESTURE_RANGE_ATTACK_SMG1,
		reload 					= 	ACT_GESTURE_RELOAD_SMG1,

		idle_panicked 			= 	{"crouchIdle_panicked4", "crouch_aim_smg1"},
		run_panicked 			= 	{"crouch_run_holding_RPG_all", "crouchRUNHOLDINGALL1"},
		walk_panicked 			= 	{"Crouch_walk_holding_RPG_all", "Crouch_walk_aiming_all"},
		walk_panicked_crouch 	= 	{ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		idle_panicked_crouch 	= 	{ACT_COVER_LOW, ACT_COVER_LOW},

		idle_depressed 			= 	{ACT_IDLE, ACT_IDLE_ANGRY_SMG1},	
		run_depressed 			= 	{ACT_RUN, ACT_RUN_AIM_RIFLE_STIMULATED},
		walk_depressed 			= 	{ACT_WALK, ACT_WALK_AIM_RIFLE_STIMULATED},
		walk_depressed_crouch 	=	{ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		idle_depressed_crouch 	=	{ACT_COVER_LOW, "crouch_aim_smg1"}
	},
	shotgun = {
		idle 					= 	{ACT_IDLE_SHOTGUN_RELAXED, ACT_IDLE_ANGRY_SMG1},
		idle_crouch 			= 	{ACT_COVER_LOW, "crouch_aim_smg1"},
		walk 					= 	{ACT_WALK_RIFLE_RELAXED, ACT_WALK_AIM_RIFLE_STIMULATED},
		walk_crouch 			= 	{ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		run 					= 	{ACT_RUN_RIFLE_RELAXED, ACT_RUN_AIM_RIFLE_STIMULATED},
		attack 					= 	ACT_GESTURE_RANGE_ATTACK_SHOTGUN,

		idle_panicked 			= 	{"crouchIdle_panicked4", "crouch_aim_smg1"},
		run_panicked 			= 	{"crouch_run_holding_RPG_all", "crouchRUNHOLDINGALL1"},
		walk_panicked 			= 	{"Crouch_walk_holding_RPG_all", "Crouch_walk_aiming_all"},
		walk_panicked_crouch 	= 	{ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		idle_panicked_crouch 	= 	{ACT_COVER_LOW, ACT_COVER_LOW},

		idle_depressed 			= 	{ACT_IDLE, ACT_IDLE_ANGRY_SMG1},	
		run_depressed 			= 	{ACT_RUN, ACT_RUN_AIM_RIFLE_STIMULATED},
		walk_depressed 			= 	{ACT_WALK, ACT_WALK_AIM_RIFLE_STIMULATED},
		walk_depressed_crouch 	=	{ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		idle_depressed_crouch 	=	{ACT_COVER_LOW, "crouch_aim_smg1"}
	},
	grenade = {
		idle 					= 	{ACT_IDLE, ACT_IDLE_MANNEDGUN},
		idle_crouch 			= 	{ACT_COVER_LOW, "crouch_aim_smg1"},
		walk 					= 	{ACT_WALK, ACT_WALK_AIM_RIFLE},
		walk_crouch 			= 	{ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		run 					= 	{ACT_RUN, ACT_RUN_AIM_RIFLE_STIMULATED},
		attack 					= 	ACT_RANGE_ATTACK_THROW,

		idle_panicked 			= 	{"crouchIdle_panicked4", "crouch_aim_smg1"},
		run_panicked 			= 	{"crouch_run_holding_RPG_all", "crouchRUNHOLDINGALL1"},
		walk_panicked 			= 	{"Crouch_walk_holding_RPG_all", "Crouch_walk_aiming_all"},
		walk_panicked_crouch 	= 	{ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		idle_panicked_crouch 	= 	{ACT_COVER_LOW, ACT_COVER_LOW},

		idle_depressed 			= 	{ACT_IDLE, ACT_IDLE_ANGRY_SMG1},	
		run_depressed 			= 	{ACT_RUN, ACT_RUN_AIM_RIFLE_STIMULATED},
		walk_depressed 			= 	{ACT_WALK, ACT_WALK_AIM_RIFLE_STIMULATED},
		walk_depressed_crouch 	=	{ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		idle_depressed_crouch 	=	{ACT_COVER_LOW, "crouch_aim_smg1"}
	},
	melee = {
		idle 					= 	{ACT_IDLE, ACT_IDLE_ANGRY_MELEE},
		idle_crouch 			= 	{ACT_COVER_LOW, "crouch_aim_smg1"},
		walk 					= 	{ACT_WALK, ACT_WALK_AIM_RIFLE},
		walk_crouch 			= 	{ACT_WALK_CROUCH, ACT_WALK_CROUCH},
		run 					= 	{ACT_RUN, ACT_RUN},
		attack 					= 	ACT_MELEE_ATTACK_SWING,

		idle_panicked 			= 	{"crouchIdle_panicked4", "crouch_aim_smg1"},
		run_panicked 			= 	{"crouch_run_holding_RPG_all", "crouchRUNHOLDINGALL1"},
		walk_panicked 			= 	{"walk_panicked_all", "Crouch_walk_aiming_all"},
		walk_panicked_crouch 	= 	{ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		idle_panicked_crouch 	= 	{ACT_COVER_LOW, ACT_COVER_LOW},

		idle_depressed 			= 	{ACT_IDLE, ACT_IDLE_ANGRY_SMG1},	
		run_depressed 			= 	{ACT_RUN, ACT_RUN_AIM_RIFLE_STIMULATED},
		walk_depressed 			= 	{ACT_WALK, ACT_WALK_AIM_RIFLE_STIMULATED},
		walk_depressed_crouch 	=	{ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		idle_depressed_crouch 	=	{ACT_COVER_LOW, "crouch_aim_smg1"}
	},
	glide = ACT_GLIDE,
	vehicle = {
		["prop_vehicle_prisoner_pod"] = {"podpose", Vector(-3, 0, 0)},
		["prop_vehicle_jeep"] = {ACT_BUSY_SIT_CHAIR, Vector(14, 0, -14)},
		["prop_vehicle_airboat"] = {ACT_BUSY_SIT_CHAIR, Vector(8, 0, -20)},
		chair = {ACT_BUSY_SIT_CHAIR, Vector(1, 0, -23)}
	},
}

nut.anim.fallout_female = {
	normal = {
		idle 					=	{ACT_IDLE, ACT_IDLE_ANGRY_SMG1},
		idle_crouch 			=	{ACT_COVER_LOW, ACT_COVER_LOW},
		walk 					=	{ACT_WALK, ACT_WALK_AIM_RIFLE_STIMULATED},
		walk_crouch 			=	{ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		run 					=	{ACT_RUN, ACT_RUN_AIM_RIFLE_STIMULATED},

		idle_panicked 			=	{"crouch_panicked", "Crouch_Idle_RPG"},
		run_panicked 			=	{"run_panicked3__all", "crouchRUNHOLDINGALL1"},
		walk_panicked 			=	{"Crouch_walk_all", "Crouch_walk_all"},
		walk_panicked_crouch 	=	{ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		idle_panicked_crouch 	=	{ACT_COVER_LOW, ACT_COVER_LOW},

		idle_depressed 			=	{"LineIdle01", ACT_IDLE_ANGRY_SMG1},
		run_depressed 			=	{"run_all", ACT_RUN_AIM_RIFLE_STIMULATED},
		walk_depressed 			=	{"walk_all_Moderate", ACT_WALK_AIM_RIFLE_STIMULATED},
		walk_depressed_crouch 	=	{ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		idle_depressed_crouch 	=	{ACT_COVER_LOW, ACT_COVER_LOW}
	},
	pistol = {
		idle 					= 	{"Pistol_idle", "Pistol_idle_aim"},
		idle_crouch 			=	{ACT_COVER_LOW, "crouch_aim_smg1"},
		walk 					= 	{ACT_WALK, ACT_WALK_AIM_PISTOL},
		walk_crouch 			= 	{ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_PISTOL},
		run 					= 	{ACT_RUN, ACT_RUN_AIM_PISTOL},
		attack 					= 	ACT_GESTURE_RANGE_ATTACK_PISTOL,
		reload 					= 	ACT_GESTURE_RELOAD_SMG1,

		idle_panicked 			= 	{"idlepackage", "Pistol_idle_aim"},
		run_panicked 			= 	{"crouch_run_holding_RPG_all", "crouchRUNHOLDINGALL1"},
		walk_panicked 			= 	{"walk_holding_package_all", "Crouch_walk_aiming_all"},
		walk_panicked_crouch 	= 	{ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		idle_panicked_crouch 	= 	{ACT_COVER_LOW, "crouch_aim_smg1"},

		idle_depressed 			= 	{"Pistol_idle", "Pistol_idle_aim"},	
		run_depressed 			= 	{ACT_RUN, ACT_RUN_AIM_RIFLE_STIMULATED},
		walk_depressed 			= 	{"walk_all", ACT_WALK_AIM_RIFLE_STIMULATED},
		walk_depressed_crouch 	=	{ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		idle_depressed_crouch 	=	{ACT_COVER_LOW, "crouch_aim_smg1"}
	},
	smg = {
		idle 					=	{ACT_IDLE_SMG1_RELAXED, ACT_IDLE_ANGRY_SMG1},
		idle_crouch 			=	{ACT_COVER_LOW, "crouch_aim_smg1"},
		walk 					=	{ACT_WALK_RIFLE_RELAXED, ACT_WALK_AIM_RIFLE_STIMULATED},
		walk_crouch 			=	{ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		run 					= 	{ACT_RUN_RIFLE_RELAXED, ACT_RUN_AIM_RIFLE_STIMULATED},
		attack 					=	ACT_GESTURE_RANGE_ATTACK_SMG1,
		reload 					=	ACT_GESTURE_RELOAD_SMG1,

		idle_panicked 			= 	{"crouch_panicked", "crouch_aim_smg1"},
		run_panicked 			= 	{"crouch_run_holding_RPG_all", "crouchRUNHOLDINGALL1"},
		walk_panicked 			= 	{"Crouch_walk_holding_RPG_all", "Crouch_walk_aiming_all"},
		walk_panicked_crouch 	= 	{ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		idle_panicked_crouch 	= 	{ACT_COVER_LOW, "crouch_aim_smg1"},

		idle_depressed 			= 	{ACT_IDLE, ACT_IDLE_ANGRY_SMG1},	
		run_depressed 			= 	{ACT_RUN, ACT_RUN_AIM_RIFLE_STIMULATED},
		walk_depressed 			= 	{ACT_WALK, ACT_WALK_AIM_RIFLE_STIMULATED},
		walk_depressed_crouch 	=	{ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		idle_depressed_crouch 	=	{ACT_COVER_LOW, "crouch_aim_smg1"}
	},
	ar2 = {
		idle 					= 	{ACT_IDLE_SHOTGUN_RELAXED, ACT_IDLE_ANGRY_RPG},
		idle_crouch 			= 	{ACT_COVER_LOW_RPG,  "crouch_aim_smg1"},
		walk 					= 	{ACT_WALK_RPG,  ACT_WALK_AIM_RIFLE_STIMULATED},
		walk_crouch 			= 	{ACT_WALK_CROUCH, "Crouch_walk_aiming_all"},
		run 					= 	{ACT_RUN, ACT_RUN_AIM_RIFLE_STIMULATED},
		attack 					= 	ACT_GESTURE_RANGE_ATTACK_SNIPER_RIFLE,
		reload 					= 	ACT_GESTURE_RELOAD_SMG1,

		idle_panicked 			= 	{"crouchIdle_panicked4", "crouch_aim_smg1"},
		run_panicked 			= 	{"crouch_run_holding_RPG_all", "crouchRUNHOLDINGALL1"},
		walk_panicked 			= 	{"walk_panicked_all", "Crouch_walk_aiming_all"},
		walk_panicked_crouch 	= 	{ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		idle_panicked_crouch 	= 	{ACT_COVER_LOW, ACT_COVER_LOW},

		idle_depressed 			= 	{ACT_IDLE, ACT_IDLE_ANGRY_SMG1},	
		run_depressed 			= 	{ACT_RUN, ACT_RUN_AIM_RIFLE_STIMULATED},
		walk_depressed 			= 	{ACT_WALK, ACT_WALK_AIM_RIFLE_STIMULATED},
		walk_depressed_crouch 	=	{ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		idle_depressed_crouch 	=	{ACT_COVER_LOW, "crouch_aim_smg1"}
	},
	shotgun = {
		idle 					=	{ACT_IDLE_SHOTGUN_RELAXED, ACT_IDLE_ANGRY_SMG1},
		idle_crouch 			=	{ACT_COVER_LOW, "crouch_aim_smg1"},
		walk 					=	{ACT_WALK_RIFLE_RELAXED, ACT_WALK_AIM_RIFLE_STIMULATED},
		walk_crouch 			=	{ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		run 					=	{ACT_RUN_RIFLE_RELAXED, ACT_RUN_AIM_RIFLE_STIMULATED},
		attack 					=	ACT_GESTURE_RANGE_ATTACK_SHOTGUN,

		idle_panicked 			= 	{"crouch_panicked", "crouch_aim_smg1"},
		run_panicked 			= 	{"crouch_run_holding_RPG_all", "crouchRUNHOLDINGALL1"},
		walk_panicked 			= 	{"Crouch_walk_holding_RPG_all", "Crouch_walk_aiming_all"},
		walk_panicked_crouch 	= 	{ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		idle_panicked_crouch 	= 	{ACT_COVER_LOW, "crouch_aim_smg1"},

		idle_depressed 			= 	{ACT_IDLE, ACT_IDLE_ANGRY_SMG1},	
		run_depressed 			= 	{ACT_RUN, ACT_RUN_AIM_RIFLE_STIMULATED},
		walk_depressed 			= 	{ACT_WALK, ACT_WALK_AIM_RIFLE_STIMULATED},
		walk_depressed_crouch 	=	{ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		idle_depressed_crouch 	=	{ACT_COVER_LOW, "crouch_aim_smg1"}
	},
	grenade = {
		idle 					=	{ACT_IDLE, ACT_IDLE_ANGRY_SMG1},
		idle_crouch 			=	{ACT_COVER_LOW, "crouch_aim_smg1"},
		walk 					=	{ACT_WALK, ACT_WALK_AIM_RIFLE_STIMULATED},
		walk_crouch 			=	{ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		run 					=	{ACT_RUN, ACT_RUN_AIM_RIFLE_STIMULATED},
		attack 					=	ACT_RANGE_ATTACK_THROW,

		idle_panicked 			= 	{"crouch_panicked", "crouch_aim_smg1"},
		run_panicked 			= 	{"crouch_run_holding_RPG_all", "crouchRUNHOLDINGALL1"},
		walk_panicked 			= 	{"Crouch_walk_holding_RPG_all", "Crouch_walk_aiming_all"},
		walk_panicked_crouch 	= 	{ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		idle_panicked_crouch 	= 	{ACT_COVER_LOW, "crouch_aim_smg1"},

		idle_depressed 			= 	{ACT_IDLE, ACT_IDLE_ANGRY_SMG1},	
		run_depressed 			= 	{ACT_RUN, ACT_RUN_AIM_RIFLE_STIMULATED},
		walk_depressed 			= 	{ACT_WALK, ACT_WALK_AIM_RIFLE_STIMULATED},
		walk_depressed_crouch 	=	{ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		idle_depressed_crouch 	=	{ACT_COVER_LOW, "crouch_aim_smg1"}
	},
	melee = {
		idle 					=	{ACT_IDLE, ACT_IDLE_MANNEDGUN},
		idle_crouch 			=	{ACT_COVER_LOW, "crouch_aim_smg1"},
		walk 					=	{ACT_WALK, ACT_WALK_AIM_RIFLE},
		walk_crouch 			=	{ACT_WALK_CROUCH, ACT_WALK_CROUCH},
		run 					=	{ACT_RUN, ACT_RUN},
		attack 					=	ACT_MELEE_ATTACK_SWING,

		idle_panicked 			= 	{"crouch_panicked", "crouch_aim_smg1"},
		run_panicked 			= 	{"crouch_run_holding_RPG_all", "crouchRUNHOLDINGALL1"},
		walk_panicked 			= 	{"Crouch_walk_holding_RPG_all", "Crouch_walk_aiming_all"},
		walk_panicked_crouch 	= 	{ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		idle_panicked_crouch 	= 	{ACT_COVER_LOW, "crouch_aim_smg1"},

		idle_depressed 			= 	{ACT_IDLE, ACT_IDLE_ANGRY_SMG1},	
		run_depressed 			= 	{ACT_RUN, ACT_RUN_AIM_RIFLE_STIMULATED},
		walk_depressed 			= 	{ACT_WALK, ACT_WALK_AIM_RIFLE_STIMULATED},
		walk_depressed_crouch 	=	{ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		idle_depressed_crouch 	=	{ACT_COVER_LOW, "crouch_aim_smg1"}
	},
	glide = ACT_GLIDE,
	vehicle = nut.anim.citizen_male.vehicle
}