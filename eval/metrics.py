from jiwer import wer, cer
from normalization import MarkPreprocessing
import pandas as pd
import numpy as np
import pickle
import sys

def remover_prefixo(dicionario):
    novo_dicionario = {}
    for chave, valor in dicionario.items():
        nova_chave = str(chave).split('/')[-1]
        novo_dicionario[nova_chave] = valor
    return novo_dicionario

pickle_file = sys.argv[1]
csv_file = sys.argv[2]

with open(pickle_file, 'rb') as arquivo:
    transcricoes = pickle.load(arquivo)

transcricoes = remover_prefixo(transcricoes)

df = pd.read_csv(csv_file)
df['transcricao_test'] = df['audio_segmentado'].map(transcricoes)
df['transcricao_test'] = df['transcricao_test'].fillna('')

wer_values = []
cer_values = []

for i in range(len(df)):
    try:
        reference = MarkPreprocessing.normalize(df.transcricao_humano[i])
        hypothesis = MarkPreprocessing.normalize(df.transcricao_test[i])
        print(reference)
        print(hypothesis)
        wer_calc = wer(reference, hypothesis)
        cer_calc = cer(reference, hypothesis)
        wer_values.append(wer_calc)
        cer_values.append(cer_calc)
    except Exception as e:
        print(f'Erro ao processar linha {i}: {str(e)}')

df['wer'] = wer_values
df['cer'] = cer_values

media_wer = np.mean(wer_values)
mediana_wer = np.median(wer_values)
media_cer = np.mean(cer_values)
mediana_cer = np.median(cer_values)

print(f"Média WER: {media_wer:.2f}")
print(f"Mediana WER: {mediana_wer:.2f}")
print(f"Média CER: {media_cer:.2f}")
print(f"Mediana CER: {mediana_cer:.2f}")

df.to_csv('output_wer_cer.csv', index = False)