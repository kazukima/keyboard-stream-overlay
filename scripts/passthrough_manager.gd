extends Node2D

# Make sure the script has direct reference to the panel it is attached to
# (got some weird true/false switch between hovering detection when not direct mention of panel)
@onready var bar_panel: PanelContainer = $"../BarPanel"
@onready var chrono_panel: PanelContainer = $"../ChronoPanel"
@onready var troubleshoot_label: Label = $"../TroubleshootLabel"
@onready var hover_feedback_label: Label = $"../HoverFeedbackLabel"
@onready var transparent_window: Node
var check_timer: Timer
var cached_bar_rect: Rect2
var cached_chrono_rect: Rect2
var cached_node_rect: Rect2
var hovering_over_clickable = false

func _ready():
	if RenderingServer.get_current_rendering_method() != "gl_compatibility": 
		troubleshoot_label.text = "Please set rendering/renderer/rendering_method to 'gl_compatibility' in Project Settings"
	# Enable window transparency
	get_viewport().transparent_bg = true

	# Set always on top FIRST
	DisplayServer.window_set_flag( DisplayServer.WINDOW_FLAG_ALWAYS_ON_TOP, true, 0 )
	# Enable window transparency (if you want a see-through background)
	DisplayServer.window_set_flag( DisplayServer.WindowFlags.WINDOW_FLAG_TRANSPARENT, true, 0 )
	# Remove window decorations (title bar, borders)
	DisplayServer.window_set_mode( DisplayServer.WINDOW_MODE_WINDOWED )
	DisplayServer.window_set_flag( DisplayServer.WindowFlags.WINDOW_FLAG_BORDERLESS, true, 0 )

	# Wait one frame before enabling passthrough
	await get_tree().process_frame
	
	# Setup timer for checking mouse position to not overload the CPU
	check_timer = Timer.new()
	check_timer.wait_time = 0.05  # 50ms
	check_timer.timeout.connect(_on_check_timer_timeout)
	add_child(check_timer)
	check_timer.start()

func _on_check_timer_timeout():
	# Make sure the parent node is assigned to the group called "transparent_window"
	transparent_window = get_tree().get_first_node_in_group("transparent_window")

	# Update cached rects only when panels move
	if bar_panel.is_queued_for_deletion() or (transparent_window == null):
		print("bar_panel queued for deletion = " + str(bar_panel.is_queued_for_deletion()) \
			+ "Transparent Window =" + str(transparent_window))
		return

	var mouse_pos = get_global_mouse_position()

	# Default hovering over clickable false by default to enable passthrough on by default
	hovering_over_clickable = false
	# Go through all of the nodes that are in the "clickable" group to see if we're hovering over them
	for i in get_tree().get_nodes_in_group("clickable"):
		cached_node_rect = i.get_global_rect()
		# If node is visible and mouse within its area then it is okay to turn off passthrough
		if i.visible and cached_node_rect.has_point(mouse_pos):
			hovering_over_clickable = true

	if hovering_over_clickable:
		# Call the C# script and turn click through off for everything
		# C# Script provided by https://github.com/matheusnicolas/keyboard-stream-overlay based on the following discussion:
		# https://www.reddit.com/r/godot/comments/1i4s2x2/does_window_set_mouse_passthrough_allow_mouse/
		transparent_window.SetClickThrough(false)
		hover_feedback_label.text = "hovering"
	else:
		# Call the C# script and turn on click through
		transparent_window.SetClickThrough(true)
		hover_feedback_label.text = "not hovering"
