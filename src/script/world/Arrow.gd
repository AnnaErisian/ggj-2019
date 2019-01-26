extends Node2D

var source
var target

func setup(sourceNode, targetNode):
	source = sourceNode
	target = targetNode
	var new_position = (target.position - source.position).normalized() * 100
	position = new_position
	rotate(new_position.angle()+PI/2)

func notifyPlayerToMove():
	var playerIndicator = $".."
	playerIndicator.moveTo(target)