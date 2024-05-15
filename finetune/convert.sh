# Verifica se o argumento $1 (diretório de dados) foi fornecido
if [ -z "$1" ]; then
    echo "Erro: Por favor, forneça o caminho para o modelo em .nemo."
    exit 1
fi

# Verifica se o argumento $2 foi fornecido
if [ -z "$2" ]; then
    echo "Erro: Por favor, forneça o nome/path para o modelo em .riva."
    exit 1
fi

nemo_file_path="$1"
riva_file_path="$2"

# Se quiser passar --key=nemotoriva como argumento
nemo2riva --out $riva_file_path $nemo_file_path