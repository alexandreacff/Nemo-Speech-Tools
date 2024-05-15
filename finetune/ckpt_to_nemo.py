import sys
import nemo.collections.asr as nemo_asr

cktp = sys.argv[1]
mymodel= nemo_asr.models.EncDecCTCModelBPE.load_from_checkpoint(checkpoint_path=cktp)
mymodel.save_to(save_path=cktp.split('--val_wer')[0]+'_v2.nemo')