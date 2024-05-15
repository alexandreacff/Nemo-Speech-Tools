#!/bin/bash

# Verifica se o argumento $1 (diretório de dados) foi fornecido
if [ -z "$1" ]; then
    echo "Erro: Por favor, forneça o diretório de dados como argumento."
    echo "Exemplo de uso: $0 /caminho/para/seu/diretorio_de_dados"
    exit 1
fi

if [ -z "$2" ]; then
    echo "Erro: Por favor, forneça o diretório da pasta NeMo como argumento."
    echo "Para baixar 'git clone https://github.com/NVIDIA/NeMo'"
    exit 1
fi

# Variável para armazenar o diretório de dados
DATA_DIR="$1"
NEMO_DIR="$2"


# Verifica se o diretório de dados existe
if [ ! -d "$DATA_DIR" ]; then
    echo "Erro: O diretório de dados '$DATA_DIR' não foi encontrado."
    exit 1
fi

# if [ ! -d "$DATA_DIR" ]; then
#     echo "Erro: O diretório de dados '$DATA_DIR' convertido em manifest.json não foi encontrado. Utilize o preprocess.py"
#     exit 1
# fi

# Comando para processar o tokenizer Python
python $NEMO_DIR/scripts/tokenizers/process_asr_text_tokenizer.py \
         --manifest="$DATA_DIR/train_manifest.json" \
         --data_root="$DATA_DIR" \
         --vocab_size=128 \
         --tokenizer=spe \
         --spe_type=unigram
