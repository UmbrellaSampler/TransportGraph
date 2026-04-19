class_name Node
extends Resource


@export var id: String = ""
@export var position: Vector3 = Vector3.ZERO
@export var name: String = ""


func _init(node_id: String = "", node_position: Vector3 = Vector3.ZERO, node_name: String = "") -> void:
	id = node_id
	position = node_position
	name = node_name


func duplicate_node() -> Node:
	return Node.new(id, position, name)