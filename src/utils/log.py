from loguru import logger
from pathlib import Path
import sys
import os

def setup_logger():
    # remove configuração padrão
    logger.remove()

    # console
    logger.add(sys.stdout, level=os.getenv("LOG_LEVEL", "INFO"))

    # arquivo
    log_dir = Path(os.getenv("DW_LOG_DIR", "C:/DW/dw_projeto/logs"))
    log_dir.mkdir(parents=True, exist_ok=True)

    # um arquivo "rolling" por dia + compressão
    logger.add(
        str(log_dir / "dw_{time:YYYY-MM-DD_HH-mm-ss}.log"),
        level=os.getenv("LOG_LEVEL", "INFO"),
        enqueue=True,
        backtrace=True,
        diagnose=False,
    )

    return logger