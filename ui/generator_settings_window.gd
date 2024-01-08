extends Window

signal generate

func _ready():
	$ScrollContainer/VBoxContainer/Seed/SpinBox.value = randi()

func _on_random_pressed():
	$ScrollContainer/VBoxContainer/Seed/SpinBox.value = randi()

func _on_elevation_corr_h_slider_value_changed(value):
	$ScrollContainer/VBoxContainer/ElevationCorr/Label2.text = str(value)

func _on_elevation_freq_h_slider_value_changed(value):
	$ScrollContainer/VBoxContainer/ElevationFreq/Label2.text = str(value)

func _on_elevation_lac_h_slider_value_changed(value):
	$ScrollContainer/VBoxContainer/ElevationLac/Label2.text = str(value)

func _on_humidity_freq_h_slider_value_changed(value):
	$ScrollContainer/VBoxContainer/HumidityFreq/Label2.text = str(value)

func _on_humidity_lac_h_slider_value_changed(value):
	$ScrollContainer/VBoxContainer/HumidityLac/Label2.text = str(value)

func _on_generate_button_pressed():
	emit_signal('generate')

func get_settings() -> Dictionary:
	return {
		"seed": $ScrollContainer/VBoxContainer/Seed/SpinBox.value,
		"size": $ScrollContainer/VBoxContainer/WorldSize/SpinBox.value,
		"elevation_correction": $ScrollContainer/VBoxContainer/ElevationCorr/HSlider.value,
		"elevation_frequency": $ScrollContainer/VBoxContainer/ElevationFreq/HSlider.value,
		"elevation_lacunarity": $ScrollContainer/VBoxContainer/ElevationLac/HSlider.value,
		"elevation_octaves": $ScrollContainer/VBoxContainer/ElevationOctaves.value,
		"humidity_frequency": $ScrollContainer/VBoxContainer/HumidityFreq/HSlider.value,
		"humidity_lacunarity": $ScrollContainer/VBoxContainer/HumidityLac/HSlider.value,
		"humidity_octaves": $ScrollContainer/VBoxContainer/HumidityOctaves.value,
	}
	
