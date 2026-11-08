from pathlib import Path
import zipfile
from oml.utils import ONNXPipeline, ONNXPipelineConfig

ROOT = Path.home / "onnx_poc"; OUT = ROOT / "kure_v1"; CACHE = ROOT / "cache" / "hf"
OUT.mkdir(parents=True, exist_ok=True)
config = ONNXPipelineConfig.from_template(
    "text", max_seq_length=8192, distance_metrics=["COSINE"], use_external_data=True)
ONNXPipeline("nlpai-lab/KURE-v1", config,
             settings={"cache_dir": str(CACHE)}).export2file("kure_v1", output_dir=str(OUT))
z = OUT / "kure_v1.zip"
if z.is_file:
    zipfile.ZipFile(z).extractall(OUT)
