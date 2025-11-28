extends Timer

func _ready():
	pass

func _add_funds(bonusFunds):
	Globals.funds+=bonusFunds
	return Globals.funds
	
func _on_timeout():
	if Globals.trustFactor < 500:
		$TimeFundsContainer/timeLabel.text="Game over"
		$"../../../../../disastersTimer".stop()
		$"../../../../../disastersTimer/tsunamiTimer".stop()
		$"../../../../../disastersTimer/fireTimer".stop()
		$"../../../../../disastersTimer/fireTimer/fireExtension".stop()
		$"../../../../../disastersTimer/floodTimer".stop()
		$"../../../../../disastersTimer/tornadoTimer".stop()
		$"../../../../../teamTimer".stop()
		$"../../../GameOver".show()
	if Globals.day<=30:
		$TimeFundsContainer/timeLabel.text=str("Month ", Globals.month, ", Day ",Globals.day)
		$TimeFundsContainer/fundsLabel.text=str("Funds: ", Globals.funds)
		$TimeFundsContainer/trustLabel.text=str("Trust Factor: ", int(Globals.trustFactor),"/1000")
		Globals.day+=1
	elif Globals.month<12:
		Globals.month+=1
		_add_funds(Globals.trustFactor*5)
		$TimeFundsContainer/fundsLabel.text=str("Funds: ", Globals.funds)
		if Globals.month==12:
			$TimeFundsContainer/timeLabel.text="Game over"
			$"../../../../../disastersTimer".stop()
			$"../../../../../disastersTimer/tsunamiTimer".stop()
			$"../../../../../disastersTimer/fireTimer".stop()
			$"../../../../../disastersTimer/fireTimer/fireExtension".stop()
			$"../../../../../disastersTimer/floodTimer".stop()
			$"../../../../../disastersTimer/tornadoTimer".stop()
			$"../../../../../teamTimer".stop()
			$"../../../GameOver".show()
		else:
			Globals.day=1
			$TimeFundsContainer/timeLabel.text=str("Month ", Globals.month, ", Day ",Globals.day)
	else:
		pass
