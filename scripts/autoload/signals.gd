extends Node

var in_game: bool = false
var menu_locked: bool = false

signal change_level(world, level, from_start)
signal coin_collected(amount)
signal player_hurt_from_enemy(knockback, damage)
signal player_hurt_enemy(damage)
signal player_hurt_boss(damage, knockback)
signal player_killed_enemy(damage, coin_amount)
signal food_collected(health_gain)
signal save()
