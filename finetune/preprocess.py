import json, librosa, os, csv

source_data_dir = f"/workspace/datasets_datametrica/dataset_datametrica_3.4"
target_data_dir = f"{source_data_dir.split('/')[-1]}_converted"
os.makedirs(target_data_dir, exist_ok=True)

def datametrica_build_manifest(transcripts_path, manifest_path, source_data_dir):
    
    with open(transcripts_path, newline='') as csvfile:
        csv_reader = csv.DictReader(csvfile)
        with open(manifest_path, 'w') as fout:

            for row in csv_reader:
                transcript = row['transcricao_normalizada']  
                print(transcript)

                audio_path =  os.path.join(source_data_dir, 'audios', row['audio_segmentado'])

                duration = librosa.core.get_duration(filename=audio_path)

                # Write the metadata to the manifest
                metadata = {"audio_filepath": audio_path, "duration": duration, "text": transcript}
                json.dump(metadata, fout)
                fout.write('\n')

# Build AN4 manifests
train_transcripts = os.path.join(source_data_dir, 'metadata/metadata_train.csv')
train_manifest = os.path.join(target_data_dir, 'train_manifest.json')
datametrica_build_manifest(train_transcripts, train_manifest, source_data_dir)

test_transcripts = os.path.join(source_data_dir, 'metadata/metadata_test.csv')
test_manifest = os.path.join(target_data_dir, 'test_manifest.json')
datametrica_build_manifest(test_transcripts, test_manifest, source_data_dir)
