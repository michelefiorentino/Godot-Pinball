extends Node

const SAVE_DIR = "user://saves/"
var save_path = SAVE_DIR + "SavedScores.dat"
var def_name_path = SAVE_DIR + "DefaultName.dat"


#salvo e carico i punteggio

func SaveScore(newScores):
	
	var dir = Directory.new()
	if !dir.dir_exists(SAVE_DIR):
		dir.make_dir_recursive(SAVE_DIR)
	
	
	var file = File.new()
	var error = file.open(save_path, File.WRITE)
	if error == OK:
		file.store_var(newScores)
		file.close()

func LoadScores():
	var file = File.new()
	if file.file_exists(save_path): #carichiamo il file
		var error = file.open(save_path, File.READ)
		if error == OK:
			var loadedScores = file.get_var()
			file.close()
			return loadedScores
	else:
			var DefaultScores = [
				{"name" : "XNO", "score" : 1000000},
				{"name" : "MAX", "score" : 800000},
				{"name" : "NIK", "score" : 600000},
				{"name" : "MIA", "score" : 350000},
				{"name" : "ALE", "score" : 200000},
				{"name" : "FRA", "score" : 120000},
				{"name" : "CIR", "score" : 60000},
				{"name" : "PIO", "score" : 45000},
				{"name" : "LEO", "score" : 40000},
				{"name" : "ANN", "score" : 30000}
			]
			SaveScore(DefaultScores) #salvo i punteggi fantoccio
			SaveDefaultName("USR") #imposto un nome di default
			file.close()
			return DefaultScores



#salvo e carico il nome di default. All'inizio è USR, ma poi diventa l'ultimo nome usato

func SaveDefaultName(newDefault):
	
	var dir = Directory.new()
	if !dir.dir_exists(SAVE_DIR):
		dir.make_dir_recursive(SAVE_DIR)
	
	
	var file = File.new()
	var error = file.open(def_name_path, File.WRITE)
	if error == OK:
		file.store_var(newDefault)
		file.close()

func LoadDefaultName():
	var file = File.new()
	if file.file_exists(def_name_path): #carichiamo il file
		var error = file.open(def_name_path, File.READ)
		if error == OK:
			var defName = file.get_var()
			file.close()
			return defName
	else:
		return "USR" #per sicurezza








