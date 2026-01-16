import requests
import json
from datetime import datetime
import config

def run_collection():
    print("🚀 [Step 1] Starting Data Collection...")
    
    # Categorized Seed Data (Massive Injection)
    seed_data = {
        # 🔴 STRICT BAN (Criminal, Drugs, Severe Abuse) - No AI Check needed
        "strict_ban": {
            "drugs": [
                "كبتاغون", "كبتاجون", "لكزس", "أبو هلالين", "زهرية", "كابتنا", "مخدرات", 
                "حشيش", "ماريجوانا", "كريستال ميث", "شبو", "هيروين", "بودرة", "شم", 
                "ترمال", "ترامادول", "زولام", "بيع كلى", "بيع كلية", "كلية للبيع"
            ],
            "weapons_market": [
                "بيع سلاح", "سلاح للبيع", "بارودة للبيع", "مسدس للبيع", "قنبلة للبيع", 
                "ذخيرة للبيع", "مطلوب سلاح", "للبيع كلاشنكوف", "للبيع روسية", "جلوك للبيع"
            ],
            "sexual_harassment": [
                "شرموطة", "قحبة", "منيوكة", "عاهرة", "كس اختك", "طيز", "فحل", "ديوث", 
                "قرن", "سكس", "محارم", "سحاق", "نيك", "ممحونة", "بنت ليل", "دعارة"
            ],
            "severe_insults": [
                "كس امك", "يا ابن القحبة", "يا ابن الشرموطة", "يا ابن الحرام", "لعن الله دينك"
            ]
        },

        # 🟡 CONTEXTUAL WATCHLIST (Politics, Sectarianism, Grey Area) - Needs AI Check
        "contextual_watchlist": {
            "political_entities": [
                "داعش", "الدولة الإسلامية", "النصرة", "هيئة تحرير الشام", "الجولاني", 
                "قسد", "PYD", "YPG", "PKK", "الجيش الحر", "الجيش الوطني", "الائتلاف", 
                "النظام السوري", "الأسد", "ماهر الأسد", "حزب الله", "حسن نصرالله", 
                "إيران", "روسيا", "الاحتلال", "الصهيوني", "الموساد", "المخابرات"
            ],
            "sectarian_slurs": [
                "نصيري", "علوية", "رافضي", "روافض", "مجوس", "صفوي", "سني", "نواصب", 
                "مرتد", "كافر", "مشرك", "ذمي", "صليبي", "درزي", "قرود", "خنازير"
            ],
            "violence_terms": [
                "ذبح", "قتل", "نحر", "دعس", "فطس", "نفق", "تصفية", "إعدام", "تفجير", 
                "انتحاري", "استشهادي", "مفخخة", "عبوة", "صاروخ", "برميل", "كيماوي"
            ],
            "controversial_symbols": [
                "🔻", "🍉", "💣", "💥", "🔪", "🩸", "🫡", "🥷", "🏴", "🏳️"
            ],
            "bullying": [
                "معاق", "منغولي", "توحد", "أهبل", "جحش", "حيوان", "غبي", "متخلف", 
                "سمين", "دبة", "فيل", "قزم", "برغي", "نوري", "قرباطي", "شرشوح"
            ],
            "scams": [
                "دولار مجمد", "دولار ليبي", "يورو مجمد", "تهريب", "طريق اليونان", 
                "لم شمل مضمون", "جواز سفر", "فيزا مضمونة", "فوركس", "تداول"
            ]
        }
    }

    collected_words = set(config.SEED_WORDS)
    
    # Flatten seed data for processing (Handles 2 levels of nesting)
    for category, subcategories in seed_data.items():
        if isinstance(subcategories, dict):
            for subcat, words in subcategories.items():
                for w in words:
                    collected_words.add(w)
        elif isinstance(subcategories, list):
             for w in subcategories:
                 collected_words.add(w)


    print(f"   ✅ Loaded massive seed dataset ({len(collected_words)} terms).")

    # Fetch from Sources
    for source in config.SOURCES:
        try:
            print(f"   Downloading {source['name']}...")
            try:
                response = requests.get(source['url'], timeout=10)
                if response.status_code == 200:
                    lines = response.text.split('\n')
                    count = 0
                    for line in lines:
                        parts = line.split('\t')
                        if len(parts) > 1:
                            text = parts[source['column_text']].strip()
                            label = parts[source['column_label']].strip()
                            
                            if label == source['hate_label']:
                                words = text.split()
                                for w in words:
                                    if len(w) > 2: 
                                        collected_words.add(w)
                                count += 1
                    print(f"   ✅ Processed {count} hate samples from source.")
                else:
                    print(f"   ❌ Failed to download {source['name']} (Status: {response.status_code})")
            except requests.exceptions.RequestException as e:
                print(f"   ❌ Network error calling source: {e}")

        except Exception as e:
            print(f"   ⚠️ Error collecting from {source['name']}: {e}")

    # Save to JSON
    data = {
        "metadata": {
            "generated_at": datetime.now().isoformat(),
            "source": "Kashef Data Factory (Sources + Categorized Seed)"
        },
        "words": list(collected_words)
    }

    with open(config.RAW_DATA_FILE, 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)
    
    print(f"✅ Step 1A Complete. Saved {len(collected_words)} unique terms to {config.RAW_DATA_FILE}")

def collect_official_policies():
    print("🤖 [Step 1B] Collecting Official Policy Violations (Facebook/X)...")
    import ai_generator # Lazy import
    
    generator = ai_generator.AIWordsGenerator()
    
    # Official Policies to scrape via AI
    policy_targets = [
        ("Facebook", "Dangerous Individuals & Organizations"),
        ("Facebook", "Bullying & Harassment"),
        ("Facebook", "Regulated Goods (Drugs/Weapons)"),
        ("Twitter", "Hateful Conduct")
    ]
    
    new_terms = set()
    
    for platform, policy in policy_targets:
        print(f"   📜 Extracting violations from {platform} for '{policy}'...")
        try:
            json_str = generator.extract_policy_terms(platform, policy)
            # Try to parse JSON
            try:
                parsed = json.loads(json_str)
                terms = []
                if 'policy_terms' in parsed:
                    terms = parsed['policy_terms']
                elif isinstance(parsed, list):
                    terms = parsed
                else:
                    for v in parsed.values():
                        if isinstance(v, list):
                            terms = v
                            break
                
                valid_count = 0
                for t in terms:
                    if isinstance(t, str) and len(t) > 1:
                        new_terms.add(t)
                        valid_count += 1
                        
                print(f"      Found {valid_count} terms.")
            except json.JSONDecodeError:
                print(f"      ⚠️ Failed to parse JSON response.")
                
        except Exception as e:
            print(f"      ⚠️ Failed to extract for {policy}: {e}")

    # Load and Merge
    try:
        with open(config.RAW_DATA_FILE, 'r', encoding='utf-8') as f:
            data = json.load(f)
            current_words = set(data['words'])
    except FileNotFoundError:
        current_words = set()

    before_count = len(current_words)
    current_words.update(new_terms)
    after_count = len(current_words)
    
    print(f"   ✨ Policy AI added {after_count - before_count} new terms.")

    data = {
        "metadata": {
            "generated_at": datetime.now().isoformat(),
            "source": "Kashef Data Factory"
        },
        "words": list(current_words)
    }

    with open(config.RAW_DATA_FILE, 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)

if __name__ == "__main__":
    run_collection()
    collect_official_policies()
