# Min-Heap Priority Queue for Godot
extends RefCounted
class_name PriorityQueue

var _heap: Array = []

func size() -> int:
	return _heap.size()

func is_empty() -> bool:
	return _heap.is_empty()

func push(priority: float, value):
	_heap.append([priority, value])
	_sift_up(_heap.size() - 1)

func pop():
	# Returns [priority, value]
	if _heap.is_empty():
		return null
	var root = _heap[0]
	var last = _heap.pop_back()
	if _heap.size() > 0:
		_heap[0] = last
		_sift_down(0)
	return root

func _sift_up(idx: int):
	while idx > 0:
		var parent = (idx - 1) >> 1
		if _heap[idx][0] < _heap[parent][0]:
			var tmp = _heap[idx]
			_heap[idx] = _heap[parent]
			_heap[parent] = tmp
			idx = parent
		else:
			break

func _sift_down(idx: int):
	var size = _heap.size()
	while true:
		var left = (idx << 1) + 1
		var right = left + 1
		var smallest = idx
		if left < size and _heap[left][0] < _heap[smallest][0]:
			smallest = left
		if right < size and _heap[right][0] < _heap[smallest][0]:
			smallest = right
		if smallest != idx:
			var tmp = _heap[idx]
			_heap[idx] = _heap[smallest]
			_heap[smallest] = tmp
			idx = smallest
		else:
			break
