class_name AIOpponent
extends RefCounted

# Private decision state: UI only receives the final gesture at reveal time.
var _secret_pair: Array[int] = []
var _final_gesture := -1

func choose_pair() -> void:
	_secret_pair = [randi_range(0, 2), randi_range(0, 2)]

func discard_one() -> void:
	_final_gesture = _secret_pair[randi_range(0, 1)]

func get_final_gesture() -> int:
	return _final_gesture
