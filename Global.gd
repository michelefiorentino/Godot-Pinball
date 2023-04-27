extends Node

func str_with_dots(number):
	var mystr = str(number)
	var mod = mystr.length() % 3
	var res = ""
	
	for i in range(0, mystr.length()):
		if i != 0 && i % 3 == mod:
			res += "."
		res += mystr[i]
	return res

