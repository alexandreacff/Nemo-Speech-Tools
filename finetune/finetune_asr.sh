#!/bin/bash

# Verifica se o argumento $1 (diretório de dados) foi fornecido
if [ -z "$1" ]; then
    echo "Erro: Por favor, forneça o diretório de dados como argumento."
    echo "Exemplo de uso: $0 /caminho/para/seu/diretorio_de_dados /caminho/para/seu/NeMo"
    exit 1
fi

if [ -z "$2" ]; then
    echo "Erro: Por favor, forneça o diretório da pasta NeMo como argumento."
    echo "Para baixar 'git clone https://github.com/NVIDIA/NeMo'"
    echo "Exemplo de uso: $0 /caminho/para/seu/diretorio_de_dados /caminho/para/seu/NeMo"
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

MODEL="stt_en_conformer_ctc_large"
python $NEMO_DIR/examples/asr/asr_ctc/speech_to_text_ctc_bpe.py \
    --config-path=../conf/conformer/ --config-name=conformer_ctc_bpe \
    +init_from_pretrained_model=$MODEL  \
    model.train_ds.manifest_filepath=$DATA_DIR/train_manifest.json \
    model.validation_ds.manifest_filepath=$DATA_DIR/test_manifest.json \
    model.tokenizer.dir=$DATA_DIR/tokenizer_spe_unigram_v128 \
    trainer.devices=1 \
    trainer.max_epochs=200 \
    model.optim.name="adamw" \
    model.optim.lr=1.0 \
    model.optim.weight_decay=0.001 \
    model.optim.sched.warmup_steps=2000 \
    ++exp_manager.exp_dir=$DATA_DIR/checkpoints \
    ++exp_manager.version=test \
    ++exp_manager.use_datetime_version=False