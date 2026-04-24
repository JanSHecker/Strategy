extends Resource
class_name Tools

static func display_high_numbers(number: float):
	var number_str = str(number)
	if number >= 1_000_000:
			# Display in millions with at most 3 decimal places
		number = number / 1_000_000
		number = snapped(number,0.001)
		number_str = str(number)
		number_str = number_str + "M"
	elif number >= 1_000:
			# Display in thousands with at most 3 decimal places
		number = number / 1_000
		number = snapped(number,0.001)
		number_str = str(number)
		number_str = number_str + "K"
	return number_str
