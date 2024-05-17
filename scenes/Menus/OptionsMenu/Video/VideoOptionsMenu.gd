extends "res://addons/maaacks_game_template/base/scenes/Menus/OptionsMenu/Video/VideoOptionsMenu.gd"


func _on_font_control_setting_changed(value):
	print("Changing font to: " + value)
	var font = load(value)
	theme.set_font("font", "Label", font)
	theme.set_font("font", "Button", font)
	theme.set_font("font", "TabBar", font)
	Config.set_config(AppSettings.VIDEO_SECTION, "font", value)
