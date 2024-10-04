extends Node2D


@onready var menu: TextMenu = $menu
@onready var menu_settings: TextMenu = find_child("menu_settings")

@export var is_world_map: bool = false


func focus() -> void:
	menu.focused = true
	visible = true
	get_tree().paused = true

func unfocus() -> void:
	menu.focused = false
	menu_settings.focused = false
	menu.reset()
	menu_settings.reset()
	visible = false
	get_tree().paused = false

func _ready() -> void:
	unfocus()
	
	if is_world_map:
		fullscreen_connector.position.y -= 67
		window_scale_connector.position.y -= 67
		master_slider_control.position.y -= 67
		music_slider_control.position.y -= 67
		sound_slider_control.position.y -= 67
		window_scale_left.position.y -= 67
		window_scale_right.position.y -= 67
		
		fullscreen_connector.position.x += 32
		window_scale_connector.position.x += 32
		master_slider_control.position.x += 32
		music_slider_control.position.x += 32
		sound_slider_control.position.x += 32
		window_scale_left.position.x += 32
		window_scale_right.position.x += 32

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause_cancel"):
		if menu.focused:
			unfocus()
		else:
			focus()


func on_menu_accepted(selection_index: int, menu_name: String) -> void:
	if menu_name == "menu":
		match selection_index:
			0:
				unfocus()
			1:
				if is_world_map:
					switch_menus()
				else:
					MarioTool.exit_level()
			2:
				if is_world_map:
					pass
				else:
					switch_menus()
			3:
				if is_world_map:
					MarioTool.quit_to_desktop()
				else:
					pass
			4:
				MarioTool.quit_to_desktop()
	elif menu_settings:
		match selection_index:
			0:
				switch_menus()
			1:
				MarioTool.toggle_fullscreen()
				fullscreen_connector.upd()
			2:
				menu_settings.focused = not menu_settings.focused
				window_scale_depth.focused = true
				$menu_settings/cursor.visible = false
				window_scale_left.visible = not window_scale_left.visible
				window_scale_right.visible = not window_scale_right.visible
			3:
				select_slider(master_volume_depth, master_slider_control)
			4:
				select_slider(music_volume_depth, music_slider_control)
			5:
				select_slider(sound_volume_depth, sound_slider_control)


func select_slider(depth, control) -> void:
	menu_settings.focused = not menu_settings.focused
	depth.focused = true
	$menu_settings/cursor.visible = false
	control.select()


@onready var window_scale_depth: MenuDepth = $menu_settings/window_scale_depth
@onready var master_volume_depth: MenuDepth = $menu_settings/master_volume_depth
@onready var music_volume_depth: MenuDepth = $menu_settings/music_volume_depth
@onready var sound_volume_depth: MenuDepth = $menu_settings/sound_volume_depth

@onready var fullscreen_connector: Node2D = get_node_or_null("menu_settings/extensions/fullscreen/connector")
@onready var window_scale_connector: Node2D = get_node_or_null("menu_settings/extensions/window_scale/connector")
@onready var master_volume_connector: Node = $menu_settings/extensions/master_volume/connector
@onready var music_volume_connector: Node = $menu_settings/extensions/music_volume/connector
@onready var sound_volume_connector: Node = $menu_settings/extensions/sound_volume/connector

@onready var master_slider_control: Node2D = get_node_or_null("menu_settings/extensions/master_volume/connector/text")
@onready var music_slider_control: Sprite2D = $menu_settings/extensions/music_volume/connector/text
@onready var sound_slider_control: Sprite2D = $menu_settings/extensions/sound_volume/connector/text


func on_depth_change(value: float, menu_name: String) -> void:
	match menu_name:
		"window_scale_depth":
			MarioTool.set_window_size(int(value))
			window_scale_connector.upd()
		"master_volume_depth":
			MarioTool.set_master_volume(value)
			master_volume_connector.upd()
		"music_volume_depth":
			MarioTool.set_music_volume(value)
			music_volume_connector.upd()
		"sound_volume_depth":
			MarioTool.set_sound_volume(value)
			sound_volume_connector.upd()

func on_depth_exit(menu_name: String) -> void:
	match menu_name:
		"window_scale_depth":
			menu_settings.focused = not menu_settings.focused
			$menu_settings/cursor.visible = true
			window_scale_left.visible = not window_scale_left.visible
			window_scale_right.visible = not window_scale_right.visible
		"master_volume_depth":
			menu_settings.focused = not menu_settings.focused
			$menu_settings/cursor.visible = true
			master_slider_control.unselect()
		"music_volume_depth":
			menu_settings.focused = not menu_settings.focused
			$menu_settings/cursor.visible = true
			music_slider_control.unselect()
		"sound_volume_depth":
			menu_settings.focused = not menu_settings.focused
			$menu_settings/cursor.visible = true
			sound_slider_control.unselect()


func switch_menus() -> void:
	menu_settings.focused = not menu_settings.focused
	menu_settings.visible = not menu_settings.visible
	menu.focused = not menu.focused
	menu.visible = not menu.visible
	
	if menu.visible:
		menu_settings.reset()
	else:
		menu.reset()
	
	fullscreen_connector.visible = not fullscreen_connector.visible
	window_scale_connector.visible = not window_scale_connector.visible
	master_slider_control.visible = not master_slider_control.visible
	music_slider_control.visible = not music_slider_control.visible
	sound_slider_control.visible = not sound_slider_control.visible


@onready var window_scale_left: Sprite2D = get_node_or_null("menu_settings/extensions/window_scale/left")
@onready var window_scale_right: Sprite2D = get_node_or_null("menu_settings/extensions/window_scale/right")

const COLOR_ENABLED = Color(1, 1, 1, 1.0)
const COLOR_DISABLED = Color(1, 1, 1, 0.5)

@onready var modulates = [
	null,
	get_node_or_null("menu_settings/extensions/fullscreen/mod"),
	get_node_or_null("menu_settings/extensions/window_scale/mod"),
	get_node_or_null("menu_settings/extensions/master_volume/mod"),
	get_node_or_null("menu_settings/extensions/music_volume/mod"),
	get_node_or_null("menu_settings/extensions/sound_volume/mod")
]

func on_menu_selection(selection_index: int, menu_name: String) -> void:
	if menu_name == "menu_settings":
		for i in modulates.size():
			if not modulates[i]:
				continue
			if i == selection_index:
				modulates[i].color = COLOR_ENABLED
			else:
				modulates[i].color = COLOR_DISABLED
