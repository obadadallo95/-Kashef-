import os

# Paths
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
RAW_DATA_FILE = os.path.join(BASE_DIR, "step1_raw.json")
EXPANDED_DATA_FILE = os.path.join(BASE_DIR, "step2_expanded.json")
DART_OUTPUT_PATH = os.path.join(BASE_DIR, "../../lib/core/constants/generated_banned_words.dart")

# Ollama Config
OLLAMA_URL = "http://localhost:11434/api/chat"
OLLAMA_MODEL = "llama3"

# Sources
SOURCES = [
    {
        "name": "L-HSAB (Levantine Hate Speech)",
        "url": "https://raw.githubusercontent.com/Hala-Mulki/L-HSAB_First-Levantine-Hate-Speech-Dataset/master/Dataset/L-HSAB",
        "type": "tsv",
        "column_text": 0,
        "column_label": 1,
        "hate_label": "hate"
    }
]

# Manual Seed Words
SEED_WORDS = [
    "دعش", "داعش", "النصرة", "تحرير الشام", "جبهة النصرة", "إرهابي", "كافر", "مرتد", "ذبح", 
    "نصيري", "رافضي", "سني", "شيعي", "علوية", "درزي", "كردي", "عربي", "انفصالي", "خنزير", "كلب"
]
