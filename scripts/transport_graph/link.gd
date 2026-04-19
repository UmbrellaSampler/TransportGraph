class_name Link
extends Resource


@export var id: String = ""
@export var start_node_id: String = ""
@export var end_node_id: String = ""
@export var directed: bool = false
@export var control_points: Array[Vector3] = []
@export var name: String = ""


func _init(
	link_id: String = "",
	link_start_node_id: String = "",
	link_end_node_id: String = "",
	link_directed: bool = false,
	link_control_points: Array[Vector3] = [],
	link_name: String = ""
) -> void:
	id = link_id
	start_node_id = link_start_node_id
	end_node_id = link_end_node_id
	directed = link_directed
	control_points = link_control_points.duplicate()
	name = link_name


func duplicate_link() -> Link:
	return Link.new(id, start_node_id, end_node_id, directed, control_points, name)