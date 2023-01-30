extends Node

func dispatch_signal(sig):
	print("dispathing %s" % sig)
	match sig:
		"activate_maho":
			GlobalState.player.get_ref().endable_mahoshojo()
