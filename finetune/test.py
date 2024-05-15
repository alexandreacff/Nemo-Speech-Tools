import json

# Caminho do arquivo JSON
json_file_path = 'dataset_datametrica_3.4_converted/train_manifest.json'

# Abrir e carregar o JSON em uma lista de dicionários
with open(json_file_path, 'r') as json_file:
    data = json.load(json_file)

# Iterar sobre cada objeto JSON na lista
for item in data:
    print("Audio Filepath:", item["audio_filepath"])
    print("Duration:", item["duration"])
    print("Text:", item["text"])
    print()
