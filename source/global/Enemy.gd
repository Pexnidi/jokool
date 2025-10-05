# SPDX-License-Identifier: AGPL-3-or-later

# ************************************
# *** Author - Pexnídi Game Studio ***
# *** File   - Enemy.gd            ***
# *** Date   - 04/10/2025          ***
# *** Update - 04/10/2025          ***
# ************************************

extends Node2D;
 
@export var nickname: String; # Enemy Name
@export var entity_id:   int; # Entity ID
@export var entity_type: int; # Entity Type
@export var enemy_type:  int; # Enemy Type
@export var health: int;      # Health Points
@export var damage: int;      # Damage Points
