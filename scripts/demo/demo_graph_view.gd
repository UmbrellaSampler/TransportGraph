extends Node3D


func _ready() -> void:
	var graph := _build_sample_graph()
	_render_graph(graph)
	_position_camera(graph)


func _build_sample_graph() -> TransportGraph:
	var graph := TransportGraph.new()
	graph.id = "demo"
	graph.name = "Demo Network"

	graph.add_node(TransportNode.new("n1", Vector3(0, 0, 0), "Hub"))
	graph.add_node(TransportNode.new("n2", Vector3(5, 0, 0), "Station A"))
	graph.add_node(TransportNode.new("n3", Vector3(2.5, 0, 4), "Station B"))

	graph.add_link(TransportLink.new("l1", "n1", "n2", true, [], "Hub to A"))
	graph.add_link(TransportLink.new("l2", "n2", "n3", false, [], "A to B"))
	graph.add_link(TransportLink.new("l3", "n3", "n1", true, [], "B to Hub"))

	return graph


func _render_graph(graph: TransportGraph) -> void:
	var node_material := StandardMaterial3D.new()
	node_material.albedo_color = Color(0.2, 0.8, 0.3)

	var link_material := StandardMaterial3D.new()
	link_material.albedo_color = Color(0.9, 0.9, 0.9)
	link_material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED

	for node in graph.nodes:
		_spawn_node_marker(node, node_material)

	for link in graph.links:
		_spawn_link_line(link, graph, link_material)


func _spawn_node_marker(node: TransportNode, material: StandardMaterial3D) -> void:
	var sphere := SphereMesh.new()
	sphere.radius = 0.25
	sphere.height = 0.5

	var mesh_instance := MeshInstance3D.new()
	mesh_instance.mesh = sphere
	mesh_instance.material_override = material
	mesh_instance.position = node.position
	mesh_instance.name = "Node_" + node.id
	add_child(mesh_instance)

	var label := Label3D.new()
	label.text = node.name
	label.position = node.position + Vector3(0, 0.6, 0)
	label.pixel_size = 0.01
	label.name = "Label_" + node.id
	add_child(label)


func _spawn_link_line(link: TransportLink, graph: TransportGraph, material: StandardMaterial3D) -> void:
	var start_node := graph.get_node_by_id(link.start_node_id)
	var end_node := graph.get_node_by_id(link.end_node_id)
	if start_node == null or end_node == null:
		return

	var immediate_mesh := ImmediateMesh.new()
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES)
	immediate_mesh.surface_add_vertex(start_node.position)
	immediate_mesh.surface_add_vertex(end_node.position)
	immediate_mesh.surface_end()

	var mesh_instance := MeshInstance3D.new()
	mesh_instance.mesh = immediate_mesh
	mesh_instance.material_override = material
	mesh_instance.name = "Link_" + link.id
	add_child(mesh_instance)


func _position_camera(graph: TransportGraph) -> void:
	if graph.nodes.is_empty():
		return

	var center := Vector3.ZERO
	for node in graph.nodes:
		center += node.position
	center /= graph.nodes.size()

	var camera := $Camera3D
	camera.position = center + Vector3(0, 8, 12)
	camera.look_at(center, Vector3.UP)
