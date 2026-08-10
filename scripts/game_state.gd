extends Node

enum Mode { PVP, PVC }
enum MatchRule { ONE_ROUND, BEST_OF_THREE, WIN_BY_TWO }
enum Stage { STAGE_1_SECRET, STAGE_2_DISCARD, REVEAL }
enum Gesture { ROCK, PAPER, SCISSORS }

var mode: Mode = Mode.PVC
var match_rule: MatchRule = MatchRule.BEST_OF_THREE
var stage: Stage = Stage.STAGE_1_SECRET
var score := [0, 0]
var player_names := ["橘子", "阿灰"]
var selections := [[], []]
var final_gestures := [-1, -1]

func reset_match() -> void:
	score = [0, 0]
	reset_round()

func reset_round() -> void:
	stage = Stage.STAGE_1_SECRET
	selections = [[], []]
	final_gestures = [-1, -1]

func resolve(a: Gesture, b: Gesture) -> int:
	if a == b:
		return 0
	if (a == Gesture.ROCK and b == Gesture.SCISSORS) or (a == Gesture.SCISSORS and b == Gesture.PAPER) or (a == Gesture.PAPER and b == Gesture.ROCK):
		return 1
	return -1

func is_match_over() -> bool:
	match match_rule:
		MatchRule.ONE_ROUND:
			return score[0] > 0 or score[1] > 0
		MatchRule.BEST_OF_THREE:
			return score[0] >= 2 or score[1] >= 2
		MatchRule.WIN_BY_TWO:
			return abs(score[0] - score[1]) >= 2 and (score[0] + score[1]) >= 2
	return false

func gesture_name(gesture: int) -> String:
	return ["石頭", "布", "剪刀"][gesture]
