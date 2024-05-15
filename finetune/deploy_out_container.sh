#!/bin/bash

# Verifica se o script está sendo executado como root
if [ "$EUID" -ne 0 ]; then
    echo "Este script precisa ser executado como root. Use sudo."
    exit 1
fi

# Verifica se o argumento $1 (diretório de dados) foi fornecido
if [ -z "$1" ]; then
    echo "Erro: Por favor, forneça o caminho do diretório em que está o .riva."
    exit 1
fi

MODEL_LOC="$1"
echo $MODEL_LOC

# Cria a pasta rmir se n existir no diretório
if [ ! -d "$MODEL_LOC/rmir" ]; then
    # Cria o diretório se não existir
    mkdir -p "$MODEL_LOC/rmir"
fi

MODEL_NAME="$2"

# Verifica se o argumento $2 foi fornecido
if [ -z "$2" ]; then
    echo "Arquivo .riva nao especificado, utilizando o .riva que está dentro do diretório indicado"
    MODEL_NAME=$(find $MODEL_LOC -maxdepth 1 -type f -name "*.riva" -printf "%f\n" -quit)
    echo "Nome do modelo: $MODEL_NAME"
fi

if [ -z "$MODEL_NAME" ]; then
    echo "Nenhum arquivo .riva encontrado no diretório fornecido."
    exit 1
fi

KEY=''
RIVA_SM_CONTAINER="nvcr.io/nvidia/riva/riva-speech:2.15.0-servicemaker"


docker run --rm --gpus 0 -v $MODEL_LOC:/data $RIVA_SM_CONTAINER -- \
    riva-build speech_recognition -f \
        /data/rmir/asr_offline_conformer_ctc.rmir:$KEY \
        /data/$MODEL_NAME:$KEY \
        --offline \
        --name=asr_offline_conformer_ctc \
        --decoder_type=greedy \
        --ms_per_timestep=40 \
        --chunk_size=4.8 \
        --left_padding_size=1.6 \
        --right_padding_size=1.6 \
        --max_batch_size=16 \
        --nn.fp16_needs_obey_precision_pass \
        --featurizer.use_utterance_norm_params=False \
        --featurizer.precalc_norm_time_steps=0 \
        --featurizer.precalc_norm_params=False \
        --featurizer.max_batch_size=512 \
        --featurizer.max_execution_batch_size=512 \
        --language_code=pt-BR

docker run --rm --gpus 0 -v $MODEL_LOC:/data $RIVA_SM_CONTAINER -- \
    riva-deploy -f  \
        /data/rmir/asr_offline_conformer_ctc.rmir:$KEY \
        /data/models/

echo "Os modelos foram carregados no diretório $MODEL_LOC"
