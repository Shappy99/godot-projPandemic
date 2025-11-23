extends Timer

var day=1
var month=0
var funds=0

func _ready():
	$".".start()

func _add_funds(bonusFunds):
	funds+=bonusFunds
	return funds
	
func _on_timeout():
	if day<=30:
		$timeLabel.text=str("Month ", month, ", Day ",day)
		$fundsLabel.text=str("Funds: ", funds)
		day+=1
	elif month<12:
		month+=1
		_add_funds(10000)
		$fundsLabel.text=str("Funds: ", funds)
		if month==12:
			$timeLabel.text="Game over"
		else:
			day=1
			$timeLabel.text=str("Month ", month, ", Day ",day)
	else:
		pass
