# Install Dependencies
pip install wget
apt-get install -y sox libsndfile1 ffmpeg libsox-fmt-mp3 
pip install text-unidecode
pip install matplotlib>=3.3.2
pip install Cython
apt-get install -y git build-essential


## Install NeMo
BRANCH='main'
python -m pip install git+https://github.com/NVIDIA/NeMo.git@$BRANCH#egg=nemo_toolkit[all]

#Convert
pip install nvidia-pyindex
ngc registry resource download-version "nvidia/riva/riva_quickstart:"$__riva_version__
pip install nemo2riva
pip install protobuf==3.20.0