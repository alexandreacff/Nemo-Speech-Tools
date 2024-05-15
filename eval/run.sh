#!/bin/bash

# Verifica se o argumento $1 foi fornecido
if [ -z "$1" ]; then
    echo "Erro: Por favor, forneça o pickle do dict com file_path e sua respectiva transcrição."
    echo "Gere o pickle com inferencia em quick_start"
    exit 1
fi

if [ -z "$2" ]; then
    echo "Erro: Por favor, forneça o csv do test com a transcrição normalizada e file_path."
    exit 1
fi

# Variável para armazenar o diretório de dados
PICKLE="$1"
CSV="$2"

python metrics.py \
         $PICKLE \
         $CSV

