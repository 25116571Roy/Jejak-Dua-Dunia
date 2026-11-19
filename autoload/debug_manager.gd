extends Node

@export var enable_debug_logs: bool = false
@export var enable_performance_logs: bool = false

var performance_metrics: Dictionary = {}

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func log(message: String, category: String = "General") -> void:
	if enable_debug_logs:
		print("[%s] %s" % [category, message])

func log_error(message: String, category: String = "Error") -> void:
	push_error("[%s] %s" % [category, message])

func log_warning(message: String, category: String = "Warning") -> void:
	push_warning("[%s] %s" % [category, message])

func log_performance(metric_name: String, value: float) -> void:
	if enable_performance_logs:
		performance_metrics[metric_name] = value
		print("[Performance] %s: %.3f" % [metric_name, value])

func get_performance_metrics() -> Dictionary:
	return performance_metrics.duplicate()

func print_performance_report() -> void:
	print("\n=== Performance Report ===")
	for metric in performance_metrics:
		print("%s: %.3f" % [metric, performance_metrics[metric]])
	print("========================\n")

func start_timer(timer_name: String) -> void:
	performance_metrics["timer_%s_start" % timer_name] = Time.get_ticks_msec()

func end_timer(timer_name: String) -> float:
	var start := performance_metrics.get("timer_%s_start" % timer_name, 0.0)
	if start == 0.0:
		log_warning("Timer %s was never started" % timer_name)
		return 0.0
	
	var elapsed := Time.get_ticks_msec() - start
	log_performance("timer_%s_ms" % timer_name, elapsed)
	return elapsed

func log_game_event(event_name: String, data: Dictionary = {}) -> void:
	log("Event: %s | Data: %s" % [event_name, data], "GameEvent")
