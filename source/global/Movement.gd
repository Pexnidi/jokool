# SPDX-License-Identifier: AGPL-3-or-later

# ************************************
# *** Author - Pexnídi Game Studio ***
# *** File   - movement.gd         ***
# *** Date   - 03/10/2025          ***
# *** Update - 04/10/2025          ***
# ************************************

extends Node2D;

# ******************************************
# +** Velocity Constants of the Enemies ****
# ******************************************

# Land Enemies
const enemy_ground_base_vx: int = 10;
const enemy_ground_base_vy: int = 00;

# Jumping Enemies
const enemy_jumping_base_vx: int = 10;
const enemy_jumping_base_vy: int = 02;

# Flyings Enemies
const enemy_flying_base_vx: int = 10;
const enemy_flying_base_vy: int = 05;

# *************************
# *** Name - enemy_vx   ***
# *** Date - 04/10/2025 ***
# *************************

"""
Behaviour:
	This function update Vector X of the enemies

Parameters:
	enemy -> Enemy

Return:
	Returing a value SUCCESS or Failure
	defined in the Equate
"""

func enemy_vx(enemy: Enemy) -> int:
	if enemy.type == Equate.ENEMY_TYPE.GROUND:
		
		return Equate.RETURN_TYPE.SUCCESS | Equate.ACTION_TYPE.MOVEMENT;
	
	return Equate.RETURN_TYPE.FAILURE | Equate.ACTION_TYPE.MOVEMENT;
