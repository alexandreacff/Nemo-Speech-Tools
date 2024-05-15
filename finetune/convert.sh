#!/bin/bash

# Verifica se foi fornecido o argumento para o diretório de dados NEMO
if [ -z "$1" ]; then
    echo "Erro: Por favor, forneça o caminho para o modelo (.nemo)."
    exit 1
fi

nemo_file_path="$1"

# Obtém o nome do diretório 
nemo_name=$(basename "$nemo_file_path" .nemo)

# Se o segundo argumento não foi fornecido, cria o nome do arquivo RIVA baseado no nome do modelo .nemo
if [ -z "$2" ]; then
    # Define o caminho e nome do arquivo RIVA baseado no nome do diretório NEMO
    riva_model="$(realpath "$(dirname "$nemo_file_path")")/$nemo_name.riva"

else
    # Se o segundo argumento foi fornecido, armazena o caminho do arquivo RIVA diretamente
    riva_model="$(realpath "$2")/$nemo_name.riva"
    
fi

echo "Path do modelo riva: $riva_model"
# Se quiser passar --key=nemotoriva como argumento
nemo2riva --out "$riva_model" "$nemo_file_path"
