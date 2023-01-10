extends TileMap


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const map_size = 105
const bound = Rect2(0, 0, map_size, map_size)

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	generate()
	for i in range(map_size):
		for j in range(map_size):
			if mapp.get_xy(i,j) == 0:
				set_cell(i,j, 3)
			elif mapp.get_xy(i,j) == 1:
				set_cell(i,j, 0)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
# impl http://journal.stuffwithstuff.com/2014/12/21/rooms-and-mazes/
# the book of the same author,crafting interpreter, is really worth reading

enum TileType{Wall, Floor}
class MapOfMap:
	var map = []
	func _init():
		for i in range(map_size * map_size):
			map.append(0)
	func set_xy(x, y, v):
		map[y * map_size + x] = v
	func get_xy(x,y):
		return map[y * map_size + x]
		
	func get_xyv(v: Vector2):
		return get_xy(v.x,v.y)
		
	func get_random_empty() -> Vector2:
		for i in range(20): # num tries
			var t = randi() % map.size()
			if map[t] == 1:
				return Vector2(t % map_size, t / map_size)
		for i in range(map_size):
			for j in range(map_size):
				if self.get_xy(i, j) == 1:
					return Vector2(i, j)
		return Vector2(1,1)
			
		

const directions = [Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN]
const numRoomTries = 40
const extraConnectoreChance = 20
const roomExtraSize = 0
const windingPercent = 0
const roomSize = 10
onready var rooms := []
onready var regions := MapOfMap.new()
onready var currentRegion := -1
onready var mapp = MapOfMap.new()

func generate():
	addRooms()
	
	
	for y in range(1, map_size, 2):
		for x in range(1, map_size, 2):
			var pos = Vector2(x,y)
			if mapp.get_xyv(pos) != 0: continue
			growMaze(pos)

	connectRegions()
	removeDeadEnds()

	for room in rooms:
		onDecorateRoom(room)
		
func onDecorateRoom(room: Rect2):
	pass

func growMaze(start: Vector2):
	var cells = []
	var lastDir
	
	startRegion()
	carve(start)
	
	cells.append(start)
	while not cells.empty():
		var cell = cells[-1]
		var unmadeCells = []
		for dir in directions:
			if canCarve(cell, dir):
				unmadeCells.append(dir)
		
		if not unmadeCells.empty():
			var dir
			if lastDir in unmadeCells and randi()%100 > windingPercent:
				dir = lastDir
			else:
				unmadeCells.shuffle()
				dir = unmadeCells[0]
			
			carve(cell + dir)
			carve(cell + dir * 2)
			
			cells.append(cell + dir * 2)
			lastDir = dir
		else:
			cells.pop_back()
			lastDir = null
	
func addRooms():
	for ii in range(numRoomTries):
		var width = randi() % roomSize + 5
		var height = randi() % roomSize + 5
		var x = randi() % (map_size - width - 5) + 1
		var y = randi() % (map_size - height - 5) + 1
		var room = Rect2(x, y, width, height)
		
		var overlaps = false
		for other in rooms:
			if room.intersects(other):
				overlaps = true
				break
		
		if overlaps: continue
		
		rooms.append(room)
		
		startRegion()
		for i in range(x, x + width):
			for j in range(y, y + height):
				carve(Vector2(i,j))
		
func connectRegions():
	var connectorRegions = {}
	for i in range(1, map_size-1):
		for j in range(1, map_size-1):
			var pos = Vector2(i, j)
			if mapp.get_xyv(pos) != 0: continue
			var regions1 = []
			for dir in directions:
				var region = regions.get_xyv(pos+dir)
				if region != 0: regions1.append(region)
			
			if regions1.size() < 2: continue
			connectorRegions[pos] = regions1
	
	var connectors = connectorRegions.keys()
	var merged = {}
	var openRegions = []
	
	for i in range(currentRegion + 1):
		merged[i] = i
		openRegions.append(i)
		
	while openRegions.size() > 1:
		connectors.shuffle()
		var connector = connectors[0]
		
		addJunction(connector)
		
		var regions0 = connectorRegions[connector]
		var regions = []
		for region in regions0:
			regions.append(merged[region])
		
		var dest = regions[0]
		var sources = []
		sources.append_array(regions)
		sources.remove(0)
		
		for i in range(currentRegion+1):
			if merged[i] in sources:
				merged[i] = dest
		
		for src in sources:
			openRegions.erase(src)
		
		# Remove any connectors that aren't needed anymore.
		# not impl
		var toRemove = []
		for pos in connectors:
			var dist: Vector2 = connector - pos
			if dist.length_squared() < 4:
				toRemove.append(pos)
			var regions1 = []
			for region in connectorRegions[pos]:
				if not merged[region] in regions1:
					regions1.append(region)
			if regions1.size() > 1: continue
			if randi() % extraConnectoreChance == 0: 
				addJunction(pos)
			toRemove.append(pos)
		for t in toRemove:
			connectors.erase(t)				
		
func addJunction(pos: Vector2):
	mapp.set_xy(pos.x, pos.y, 1)
func removeDeadEnds():
	var done = false
	while not done:
		done = true
		for i in range(1, map_size-1):
			for j in range(1, map_size-1):
				var pos = Vector2(i, j)
				if mapp.get_xy(i, j) == 0: continue
				
				var exits = 0
				
				for dir in directions:
					if mapp.get_xyv(pos+dir) != 0: exits+=1
				
				if exits != 1: continue
				
				done = false
				mapp.set_xy(i, j, 0)
func canCarve(pos: Vector2, direction: Vector2):
	var sum = pos + direction * 3
	if not bound.has_point(sum): return false
	sum = pos + direction * 2
	return mapp.get_xyv(sum) == 0
	
func startRegion():
	currentRegion += 1

func carve(pos: Vector2):
	regions.set_xy(pos.x, pos.y, currentRegion)
	mapp.set_xy(pos.x, pos.y, 1)
		
	
	
