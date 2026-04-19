class_name Graph
extends Resource


@export var format_version: String = "0.1"
@export var id: String = ""
@export var name: String = ""
@export var nodes: Array[Node] = []
@export var links: Array[Link] = []


func has_node(node_id: String) -> bool:
	return get_node_by_id(node_id) != null


func get_node_by_id(node_id: String) -> Node:
	for node in nodes:
		if node != null and node.id == node_id:
			return node
	return null


func get_link_by_id(link_id: String) -> Link:
	for link in links:
		if link != null and link.id == link_id:
			return link
	return null


func add_node(node: Node) -> void:
	assert(node != null, "node must not be null")
	assert(node.id != "", "node.id must not be empty")
	assert(not has_node(node.id), "node.id must be unique within the graph")
	nodes.append(node)


func remove_node(node_id: String) -> void:
	for index in range(nodes.size()):
		var node := nodes[index]
		if node != null and node.id == node_id:
			nodes.remove_at(index)
			_remove_links_for_node(node_id)
			return


func add_link(link: Link) -> void:
	assert(link != null, "link must not be null")
	assert(link.id != "", "link.id must not be empty")
	assert(get_link_by_id(link.id) == null, "link.id must be unique within the graph")
	assert(has_node(link.start_node_id), "link.start_node_id must reference an existing node")
	assert(has_node(link.end_node_id), "link.end_node_id must reference an existing node")
	links.append(link)


func remove_link(link_id: String) -> void:
	for index in range(links.size()):
		var link := links[index]
		if link != null and link.id == link_id:
			links.remove_at(index)
			return


func duplicate_graph() -> Graph:
	var result := Graph.new()
	result.format_version = format_version
	result.id = id
	result.name = name
	for node in nodes:
		if node != null:
			result.nodes.append(node.duplicate_node())
	for link in links:
		if link != null:
			result.links.append(link.duplicate_link())
	return result


func _remove_links_for_node(node_id: String) -> void:
	for index in range(links.size() - 1, -1, -1):
		var link := links[index]
		if link != null and (link.start_node_id == node_id or link.end_node_id == node_id):
			links.remove_at(index)