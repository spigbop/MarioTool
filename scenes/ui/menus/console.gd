extends Node2D
class_name Console


enum CONSOLE_STATE { DISABLED, OPAQUE, SEMI_OPAQUE }
var state: CONSOLE_STATE = CONSOLE_STATE.DISABLED:
	set(newval):
		state = newval
		lights_overlay.frame = state
		match state:
			CONSOLE_STATE.DISABLED:
				root.visible = false
				mod.color = Color.WHITE
				get_tree().paused = false
				PauseMenu.interrupted = false
				console_line.focused = false
				fps_updater.stop()
				var level_ov = MarioTool.get_level_overlay()
				if level_ov:
					level_ov.visible = true
			CONSOLE_STATE.OPAQUE:
				var cam = MarioTool.get_main_camera()
				if cam:
					position = cam.position
				root.visible = true
				get_tree().paused = true
				PauseMenu.interrupted = true
				console_line.focused = true
				var level_ov = MarioTool.get_level_overlay()
				if level_ov:
					level_ov.visible = false
				fps_updater.start()
			CONSOLE_STATE.SEMI_OPAQUE:
				mod.color = Color(1.0, 1.0, 1.0, 0.5)

var context_ind: int = 0
var context = MarioTool.inst


@onready var root: Node2D = $layer/root
@onready var mod: CanvasModulate = $layer/mod
@onready var console_line: TextBox = $layer/root/console_line

@onready var lights_overlay: AnimatedSprite2D = $layer/root/lights_overlay

@onready var light_main: AnimatedSprite2D = $layer/root/lights_context/main
@onready var light_level: AnimatedSprite2D = $layer/root/lights_context/level
@onready var light_player: AnimatedSprite2D = $layer/root/lights_context/player

@onready var fps_updater: Timer = $layer/root/fps_connector/updater

static var inst: Console = null


func _ready() -> void:
	if inst:
		queue_free()
		return
	inst = self
	log_text = $layer/root/log
	state = CONSOLE_STATE.DISABLED

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("debug_toggle_console") and get_tree().paused == root.visible:
		state = Mathx.clampi_cycle(state + 1, 0, 2)
	if state == CONSOLE_STATE.DISABLED:
		return
	if Input.is_action_just_pressed("debug_console_context") and get_tree().paused == root.visible:
		context_ind = Mathx.clampi_cycle(context_ind + 1, 0, 2)
		match(context_ind):
			0:
				context = MarioTool.inst
				light_main.frame = 0
				light_player.frame = 1
			1:
				context = MarioTool.get_level_base()
				light_level.frame = 0
				light_main.frame = 1
			2:
				context = MarioTool.get_player()
				light_player.frame = 0
				light_level.frame = 1
	if Input.is_action_just_pressed("pause_cancel") and not state == CONSOLE_STATE.DISABLED:
		state = CONSOLE_STATE.DISABLED
	if Input.is_action_just_pressed("up_interact") or Input.is_action_just_pressed("down_duck"):
		var current = console_line.text
		console_line.text = alt_submit
		console_line.subject.text = alt_submit
		console_line.caret_column = alt_submit.length()
		alt_submit = current

static var log_text: Text = null
static var alt_submit: String = ""

func on_submit(submission: String) -> void:
	var subtext = apply_placeholders(submission)
	alt_submit = subtext
	
	match subtext.replace(" ", ""):
		"":
			return
		
		"clear":
			log_text.text = ""
			return
	
	if submission.begins_with("%"):
		println(subtext)
		return
	
	elif submission.begins_with("methods"):
		var fun_list = context.get_script().get_script_method_list()
		if subtext.length() > 8:
			help_log(fun_list, int(subtext.right(-8)) - 1)
		else:
			help_log(fun_list)
		return
	
	elif submission.begins_with("props"):
		var var_list = context.get_script().get_script_property_list()
		if subtext.length() > 6:
			help_log(var_list, int(subtext.right(-6)) - 1)
		else:
			help_log(var_list)
		return
	
	if not is_instance_valid(context):
		context = Mathx.bool_gate(context_ind == 2, MarioTool.get_player(), MarioTool.get_level_base())
	
	var ret = Deferation.execute_on(context, [subtext])
	if str(ret).contains("::"):
		println("If you intended to call, use () after.")
	if str(ret) == "0":
		println("Bad syntax, try 'props' or 'methods'")
	elif str(ret) == "<null>":
		println("-> " + subtext.replace(" ", ""))
	elif str(ret) == "<no_prop>":
		println("Failed to find property: " + subtext)
	elif str(ret) == "<no_method>":
		println("Failed to find method: " + subtext)
	else:
		println(str(ret))
	get_tree().paused = true

static func apply_placeholders(what: String) -> String:
	if what.contains("%dt"):
		what = what.replace("%dt", str(inst.get_process_delta_time()))
	if what.contains("%pdt"):
		what = what.replace("%pdt", str(inst.get_physics_process_delta_time()))
	if what.contains("!adv"):
		what = what.replace("!adv", "_process(" + str(inst.get_process_delta_time()) + ")")
	if what.contains("!pdv"):
		what = what.replace("!pdv", "_physics_process(" + str(inst.get_process_delta_time()) + ")")
	return what

func help_log(list, page = 0) -> void:
	if page < 0:
		page = 0
	
	var max_pages = (list.size() - 1) / 8
	if page > max_pages:
		help_log(list, max_pages)
		return
	
	var i = page * 8
	log_text.auto_print = false
	println("-----")
	while i < 8 + (page * 8):
		if list.size() <= i:
			break
		
		var fun_name = list[i].name
		if "args" in list[i]:
			fun_name = fun_name + "("
			var args = list[i].args
			var ai = 0
			for a in args:
				fun_name = fun_name + Mathx.bool_gate(ai == 0, "", ",") + a.name.substr(0, 3)
				ai += 1
			fun_name = fun_name + ")"
		
		println(fun_name)
		i += 1
	println("Showing page " + str(page + 1) + " of " + str(max_pages + 1) + " (" + str(page * 8 + 1) + "-" + str(min(page * 8 + 8, list.size())) + ")")
	println("-----")
	log_text.auto_print = true
	log_text.print_text()

static func println(line: String) -> void:
	if not log_text:
		return
	
	if line.length() == 0:
		return
	
	log_text.text = line.substr(0, 39) + "\\n" + log_text.text
	
	var lines = log_text.text.split("\\n")
	if lines.size() > 11:
		var newlines: PackedStringArray = []
		var i = 0
		while i < 11:
			newlines.append(lines[i])
			i += 1
		log_text.text = "\\n".join(newlines)
