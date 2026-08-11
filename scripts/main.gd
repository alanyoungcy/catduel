extends Control

const AI = preload("res://scripts/ai_opponent.gd")
const UI_FONT = preload("res://assets/fonts/NotoSansTC-Regular.otf")
const BG_COLOR := Color("#fff5ed")
const INK := Color("#503c49")
const PINK := Color("#ff9fb5")
const BLUE := Color("#95cde5")
const CREAM := Color("#fffaf4")

var content: VBoxContainer
var ai := AI.new()
var current_actor := 0
var picked: Array[int] = []
var audio_player: AudioStreamPlayer

func _ready() -> void:
	audio_player = AudioStreamPlayer.new()
	audio_player.volume_db = -15.0
	add_child(audio_player)
	show_title()

func wipe() -> void:
	for child in get_children():
		if child != audio_player:
			child.queue_free()
	var backdrop := TextureRect.new()
	backdrop.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	backdrop.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	backdrop.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	if ResourceLoader.exists("res://assets/backgrounds/battle_arena.png"):
		backdrop.texture = load("res://assets/backgrounds/battle_arena.png")
	else:
		backdrop.modulate = BG_COLOR
	backdrop.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(backdrop)
	var shade := ColorRect.new()
	shade.color = Color(1, 0.97, 0.93, 0.18)
	shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	shade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(shade)
	content = VBoxContainer.new()
	content.set_anchors_preset(Control.PRESET_TOP_LEFT)
	content.position = Vector2(180, 55)
	content.size = Vector2(920, 610)
	content.alignment = BoxContainer.ALIGNMENT_CENTER
	content.add_theme_constant_override("separation", 16)
	add_child(content)

func label(text: String, font_size := 26, color := INK) -> Label:
	var node := Label.new()
	node.text = text
	node.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	node.add_theme_font_override("font", UI_FONT)
	node.add_theme_font_size_override("font_size", font_size)
	node.add_theme_color_override("font_color", color)
	node.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	return node

func button(text: String, action: Callable, color := PINK) -> Button:
	var node := Button.new()
	node.text = text
	node.custom_minimum_size = Vector2(310, 62)
	node.add_theme_font_override("font", UI_FONT)
	node.add_theme_font_size_override("font_size", 24)
	node.add_theme_color_override("font_color", INK)
	var normal := StyleBoxFlat.new()
	normal.bg_color = color
	normal.corner_radius_top_left = 22
	normal.corner_radius_top_right = 22
	normal.corner_radius_bottom_left = 22
	normal.corner_radius_bottom_right = 22
	normal.content_margin_top = 9
	normal.content_margin_bottom = 9
	var hover := normal.duplicate()
	hover.bg_color = color.lightened(0.12)
	node.add_theme_stylebox_override("normal", normal)
	node.add_theme_stylebox_override("hover", hover)
	node.pressed.connect(action)
	return node

func card() -> PanelContainer:
	var panel := PanelContainer.new()
	var style := StyleBoxFlat.new()
	style.bg_color = Color(1, 1, 1, 0.86)
	style.corner_radius_top_left = 30
	style.corner_radius_top_right = 30
	style.corner_radius_bottom_left = 30
	style.corner_radius_bottom_right = 30
	style.border_width_left = 3
	style.border_width_right = 3
	style.border_width_top = 3
	style.border_width_bottom = 3
	style.border_color = Color("#ffffff")
	style.content_margin_left = 28
	style.content_margin_right = 28
	style.content_margin_top = 22
	style.content_margin_bottom = 22
	panel.add_theme_stylebox_override("panel", style)
	return panel

func centered(node: Control) -> void:
	var row := HBoxContainer.new()
	row.custom_minimum_size = Vector2(920, 0)
	row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.alignment = BoxContainer.ALIGNMENT_CENTER
	if node is Label:
		node.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(node)
	content.add_child(row)

func show_title() -> void:
	wipe()
	content.add_spacer(true)
	centered(label("貓咪二段式剪刀石頭布", 42, Color("#e76f91")))
	centered(label("秘密選兩個，再悄悄刪一個！", 25))
	var cats := HBoxContainer.new()
	cats.alignment = BoxContainer.ALIGNMENT_CENTER
	cats.add_theme_constant_override("separation", 70)
	cats.add_child(make_cat("橘子", "res://assets/characters/juzi.png", Color("#ffb66e")))
	cats.add_child(make_cat("阿灰", "res://assets/characters/ahui.png", Color("#aeb5c4")))
	content.add_child(cats)
	centered(button("開始遊戲", show_player_mode, PINK))
	content.add_spacer(true)

func make_cat(name: String, path: String, fallback_color: Color, motion := "idle") -> VBoxContainer:
	var box := VBoxContainer.new()
	box.custom_minimum_size = Vector2(220, 270)
	box.alignment = BoxContainer.ALIGNMENT_CENTER
	if ResourceLoader.exists(path):
		var image := TextureRect.new()
		image.texture = load(path)
		image.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		image.custom_minimum_size = Vector2(210, 220)
		box.add_child(image)
		call_deferred("animate_cat", image, motion)
	else:
		var face := label("貓咪", 56, fallback_color)
		face.custom_minimum_size = Vector2(210, 220)
		box.add_child(face)
	box.add_child(label(name, 25))
	return box

func animate_cat(image: TextureRect, motion: String) -> void:
	image.pivot_offset = image.custom_minimum_size * 0.5
	var tween := create_tween()
	if motion == "gesture":
		image.scale = Vector2(0.78, 0.78)
		tween.tween_property(image, "scale", Vector2(1.16, 1.16), 0.16).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		tween.tween_property(image, "scale", Vector2.ONE, 0.12).set_trans(Tween.TRANS_SINE)
		return
	tween.set_loops()
	if motion == "victory":
		tween.tween_property(image, "scale", Vector2(1.12, 0.90), 0.28).set_trans(Tween.TRANS_SINE)
		tween.tween_property(image, "scale", Vector2(0.93, 1.08), 0.28).set_trans(Tween.TRANS_SINE)
	else:
		tween.tween_property(image, "scale", Vector2(1.025, 0.975), 0.65).set_trans(Tween.TRANS_SINE)
		tween.tween_property(image, "scale", Vector2(0.975, 1.025), 0.65).set_trans(Tween.TRANS_SINE)

func play_tone(frequency: float, duration: float = 0.12, rising: bool = false) -> void:
	var rate: int = 22050
	var samples: int = max(1, int(rate * duration))
	var data := PackedByteArray()
	data.resize(samples * 2)
	for index in samples:
		var t := float(index) / rate
		var sweep: float = frequency + (frequency * 0.38 * t / duration if rising else 0.0)
		var envelope: float = min(1.0, t * 55.0) * min(1.0, (duration - t) * 24.0)
		var sample: int = int(sin(TAU * sweep * t) * envelope * 0.22 * 32767.0)
		data.encode_s16(index * 2, sample)
	var wav := AudioStreamWAV.new()
	wav.format = AudioStreamWAV.FORMAT_16_BITS
	wav.mix_rate = rate
	wav.stereo = false
	wav.data = data
	audio_player.stream = wav
	audio_player.play()

func play_meow(is_win: bool) -> void:
	play_tone(620.0 if is_win else 390.0, 0.34, is_win)

func cat_asset(actor: int, action: String) -> String:
	var cat := "juzi" if actor == 0 else "ahui"
	var action_path := "res://assets/animations/%s/frames/%s.png" % [cat, action]
	if ResourceLoader.exists(action_path):
		return action_path
	return "res://assets/characters/%s.png" % cat

func duel_preview(action: String) -> HBoxContainer:
	var cats := HBoxContainer.new()
	cats.alignment = BoxContainer.ALIGNMENT_CENTER
	cats.add_theme_constant_override("separation", 90)
	cats.add_child(make_cat(GameState.player_names[0], cat_asset(0, action), Color.WHITE))
	cats.add_child(make_cat(GameState.player_names[1], cat_asset(1, action), Color.WHITE))
	return cats

func start_countdown(title: String, next: Callable) -> void:
	wipe()
	content.add_spacer(true)
	centered(label(title, 35, Color("#e76f91")))
	content.add_child(duel_preview("windup"))
	var count_label := label("3", 104, Color("#e76f91"))
	centered(count_label)
	centered(label("準備好你的貓爪！", 23))
	content.add_spacer(true)
	for number in [3, 2, 1]:
		count_label.text = str(number)
		play_tone(500.0 + (3 - number) * 120.0, 0.13, true)
		await get_tree().create_timer(0.58).timeout
	play_tone(980.0, 0.18, true)
	next.call()

func show_player_mode() -> void:
	wipe()
	content.add_spacer(true)
	centered(label("選擇對戰方式", 36, Color("#e76f91")))
	centered(label("雙人模式會在每次秘密選擇時遮蔽畫面。", 20))
	centered(button("雙人本機對戰", func(): GameState.mode = GameState.Mode.PVP; show_match_rule(), BLUE))
	centered(button("挑戰電腦 阿灰", func(): GameState.mode = GameState.Mode.PVC; show_match_rule(), PINK))
	centered(button("返回主選單", show_title, Color("#e8ded8")))
	content.add_spacer(true)

func show_match_rule() -> void:
	wipe()
	content.add_spacer(true)
	centered(label("選擇賽制", 36, Color("#e76f91")))
	add_rule("單局定勝負", "贏下一回合的貓咪就是贏家。", GameState.MatchRule.ONE_ROUND)
	add_rule("三盤兩勝", "先拿到 2 個勝場者獲勝。", GameState.MatchRule.BEST_OF_THREE)
	add_rule("先淨勝 2 局", "持續對戰，直到任一方領先 2 個勝場。", GameState.MatchRule.WIN_BY_TWO)
	centered(button("返回", show_player_mode, Color("#e8ded8")))
	content.add_spacer(true)

func add_rule(title: String, description: String, rule: int) -> void:
	var group := VBoxContainer.new()
	group.alignment = BoxContainer.ALIGNMENT_CENTER
	group.add_child(button(title, func(): GameState.match_rule = rule; GameState.reset_match(); begin_round(), PINK))
	group.add_child(label(description, 18))
	content.add_child(group)

func begin_round() -> void:
	GameState.reset_round()
	if GameState.mode == GameState.Mode.PVC:
		ai.choose_pair()
	stage_one(0)

func stage_one(actor: int) -> void:
	current_actor = actor
	picked = []
	start_countdown("第一階段即將開始", render_stage_one)

func render_stage_one() -> void:
	wipe()
	content.add_spacer(true)
	centered(label("第一階段：秘密選兩個", 34, Color("#e76f91")))
	centered(label("%s，請選擇兩個貓爪手勢（可重複）" % GameState.player_names[current_actor], 22))
	centered(label("已選：%d / 2" % picked.size(), 20, Color("#806775")))
	add_gesture_buttons("選擇")
	content.add_spacer(true)

func add_gesture_buttons(prefix: String) -> void:
	var row := HBoxContainer.new()
	row.alignment = BoxContainer.ALIGNMENT_CENTER
	row.add_theme_constant_override("separation", 18)
	for gesture in [GameState.Gesture.ROCK, GameState.Gesture.PAPER, GameState.Gesture.SCISSORS]:
		row.add_child(button("%s %s" % [prefix, GameState.gesture_name(gesture)], func(): choose_gesture(gesture), [Color("#ffd6a5"), Color("#bde0fe"), Color("#cdeac0")][gesture]))
	content.add_child(row)

func choose_gesture(gesture: int) -> void:
	play_tone(610.0, 0.08, true)
	picked.append(gesture)
	if picked.size() < 2:
		render_stage_one()
		return
	GameState.selections[current_actor] = picked.duplicate()
	if GameState.mode == GameState.Mode.PVC or current_actor == 1:
		stage_two(0)
	else:
		pass_device(1, func(): stage_one(1))

func stage_two(actor: int) -> void:
	current_actor = actor
	start_countdown("第二階段即將開始", render_stage_two)

func render_stage_two() -> void:
	wipe()
	content.add_spacer(true)
	centered(label("第二階段：秘密刪一個", 34, Color("#e76f91")))
	centered(label("%s，選擇要保留的最終手勢" % GameState.player_names[current_actor], 22))
	var row := HBoxContainer.new()
	row.alignment = BoxContainer.ALIGNMENT_CENTER
	row.add_theme_constant_override("separation", 20)
	for index in GameState.selections[current_actor].size():
		var gesture: int = GameState.selections[current_actor][index]
		row.add_child(button("保留 %s" % GameState.gesture_name(gesture), func(): keep_gesture(index), [Color("#ffd6a5"), Color("#bde0fe"), Color("#cdeac0")][gesture]))
	content.add_child(row)
	content.add_spacer(true)

func keep_gesture(index: int) -> void:
	play_tone(720.0, 0.1, true)
	GameState.final_gestures[current_actor] = GameState.selections[current_actor][index]
	if GameState.mode == GameState.Mode.PVC:
		ai.discard_one()
		GameState.final_gestures[1] = ai.get_final_gesture()
		show_reveal()
	elif current_actor == 0:
		pass_device(1, func(): stage_two(1))
	else:
		show_reveal()

func pass_device(next_actor: int, next: Callable) -> void:
	wipe()
	content.add_spacer(true)
	centered(label("祕密交接時間", 39, Color("#e76f91")))
	centered(label("請將裝置交給 %s" % GameState.player_names[next_actor], 31))
	centered(label("上一位玩家的手勢已經完全遮蔽。", 20))
	centered(button("我是 %s，開始選擇" % GameState.player_names[next_actor], next, BLUE))
	content.add_spacer(true)

func show_reveal() -> void:
	GameState.stage = GameState.Stage.REVEAL
	wipe()
	content.add_spacer(true)
	centered(label("同時公開！", 39, Color("#e76f91")))
	var showdown := HBoxContainer.new()
	showdown.alignment = BoxContainer.ALIGNMENT_CENTER
	showdown.add_theme_constant_override("separation", 72)
	showdown.add_child(result_card(0))
	showdown.add_child(label("VS", 36, Color("#e76f91")))
	showdown.add_child(result_card(1))
	content.add_child(showdown)
	var outcome := GameState.resolve(GameState.final_gestures[0], GameState.final_gestures[1])
	var text := "平手！本回合重賽，不計分。"
	if outcome != 0:
		GameState.score[0 if outcome == 1 else 1] += 1
		text = "%s 贏得這一回合！" % GameState.player_names[0 if outcome == 1 else 1]
	play_meow(outcome != -1)
	centered(label(text, 29, Color("#d35d80")))
	centered(label("比分：橘子 %d － %d 阿灰" % [GameState.score[0], GameState.score[1]], 23))
	centered(button("繼續", advance_after_result, PINK))
	content.add_spacer(true)
	var tween := create_tween()
	content.scale = Vector2(0.92, 0.92)
	tween.tween_property(content, "scale", Vector2.ONE, 0.25).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func result_card(actor: int) -> Control:
	var panel := card()
	panel.custom_minimum_size = Vector2(300, 265)
	var column := VBoxContainer.new()
	column.alignment = BoxContainer.ALIGNMENT_CENTER
	column.add_child(label(GameState.player_names[actor], 24))
	var cat := TextureRect.new()
	var action: String = ["rock", "paper", "scissors"][GameState.final_gestures[actor]]
	var path := cat_asset(actor, action)
	if ResourceLoader.exists(path):
		cat.texture = load(path)
	cat.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	cat.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	cat.custom_minimum_size = Vector2(200, 150)
	column.add_child(cat)
	call_deferred("animate_cat", cat, "gesture")
	column.add_child(label(GameState.gesture_name(GameState.final_gestures[actor]), 25))
	panel.add_child(column)
	return panel

func advance_after_result() -> void:
	if GameState.is_match_over():
		show_match_result()
	else:
		begin_round()

func show_match_result() -> void:
	wipe()
	var winner := 0 if GameState.score[0] > GameState.score[1] else 1
	content.add_spacer(true)
	centered(label("%s 獲勝！" % GameState.player_names[winner], 43, Color("#e76f91")))
	var cats := HBoxContainer.new()
	cats.alignment = BoxContainer.ALIGNMENT_CENTER
	cats.add_theme_constant_override("separation", 90)
	cats.add_child(make_cat(GameState.player_names[winner], cat_asset(winner, "victory"), Color.WHITE, "victory"))
	cats.add_child(make_cat(GameState.player_names[1 - winner], cat_asset(1 - winner, "defeat"), Color.WHITE, "idle"))
	content.add_child(cats)
	centered(label("最終比分：橘子 %d － %d 阿灰" % [GameState.score[0], GameState.score[1]], 25))
	centered(button("再來一局", func(): GameState.reset_match(); begin_round(), PINK))
	centered(button("返回主選單", show_title, Color("#e8ded8")))
	content.add_spacer(true)
