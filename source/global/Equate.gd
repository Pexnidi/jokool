# SPDX-License-Identifier: AGPL-3-or-later

# ************************************
# *** Author - Pexnídi Game Studio ***
# *** File   - Equate.gd           ***
# *** Date   - 04/10/2025          ***
# *** Update - 04/10/2025          ***
# ************************************

extends Node2D;

# ********************
# *** Base Bitwise ***
# ********************

const BASE_RETURN: int = 0x00000000;
const BASE_ACTION: int = 0x00000010;
const BASE_ENTITY: int = 0x00000100;

# **********************
# *** Type of Return ***
# **********************

enum RETURN_TYPE {
	SUCCESS = BASE_RETURN ^ 0x00000000,
	FAILURE = BASE_RETURN ^ 0x00000001
}

# **********************
# *** Type of Action ***
# **********************

enum ACTION_TYPE {
	MOVEMENT = BASE_ACTION ^ 0x00000000
}

# **********************
# *** Type of Entity ***
# **********************

enum ENTITY_TYPE {
	PLAYER = BASE_ENTITY ^ 0x00000000,
	ALLY   = BASE_ENTITY ^ 0x00000001,
	ENEMY  = BASE_ENTITY ^ 0x00000002,
	BOSS   = BASE_ENTITY ^ 0x00000003
}

# *********************
# *** Type of Enemy ***
# *********************

enum ENEMY_TYPE {
	GROUND  = ENTITY_TYPE.ENEMY ^ 0x00000000,
	JUMPING = ENTITY_TYPE.ENEMY ^ 0x00000001,
	FLYING  = ENTITY_TYPE.ENEMY ^ 0x00000002
}
