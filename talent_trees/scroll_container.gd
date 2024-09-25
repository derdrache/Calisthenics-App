extends ScrollContainer

var offSet = Vector2(0,-200)

func _process(delta):
	queue_redraw()

func _draw():
	for talentNode in get_tree().get_nodes_in_group("talents"):
		if talentNode.talentResource ==null: continue

		for resource in talentNode.talentResource.unlocks:
			var targetNode = _get_node_with_resource(resource)
			var sourcePosition = (talentNode.global_position + talentNode.get_center() + offSet) / %ScrollContainer.scale
			print(sourcePosition)
			if targetNode == null: 
				push_error(talentNode, " talent not available")
				continue
			
			var targetPosition = (targetNode.global_position + targetNode.get_center() + offSet) / %ScrollContainer.scale
			var color = Color.BLACK if talentNode.talentResource.is_unlocked else Color.GRAY
			
			draw_line(sourcePosition, targetPosition, color, 7.0)
			
func _get_node_with_resource(resource):
	for talentNode in get_tree().get_nodes_in_group("talents"):
		if talentNode.talentResource == resource:
			return talentNode
