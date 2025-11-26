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
	if randi()%3==1:
		$"../../../../../map/worldGen".set_on_fire(Vector2i(randi()%28,randi()%18))
	if day<=30:
		$TimeFundsContainer/timeLabel.text=str("Month ", month, ", Day ",day)
		$TimeFundsContainer/fundsLabel.text=str("Funds: ", funds)
		day+=1
	elif month<12:
		month+=1
		_add_funds(10000)
		$TimeFundsContainer/fundsLabel.text=str("Funds: ", funds)
		if month==12:
			$TimeFundsContainer/timeLabel.text="Game over"
		else:
			day=1
			$TimeFundsContainer/timeLabel.text=str("Month ", month, ", Day ",day)
	else:
		pass
