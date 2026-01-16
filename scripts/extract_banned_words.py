import urllib.request
import csv
import io
import re

# URLs for datasets (Raw GitHub Links)
LHSAB_TRAIN = "https://raw.githubusercontent.com/Hala-Mulki/L-HSAB-First-Arabic-Levantine-HateSpeech-Dataset/master/train.tsv"
LHSAB_TEST = "https://raw.githubusercontent.com/Hala-Mulki/L-HSAB-First-Arabic-Levantine-HateSpeech-Dataset/master/test.tsv"

# Output File
OUTPUT_DART_FILE = "lib/core/constants/generated_banned_words.dart"

def download_and_parse_lhsab(url):
    print(f"Downloading L-HSAB from {url}...")
    bad_tweets = []
    try:
        with urllib.request.urlopen(url) as response:
            content = response.read().decode('utf-8')
            
        # Try tab separation first
        f = io.StringIO(content)
        reader = csv.DictReader(f, delimiter='\t')
        
        # Check if 'Class' column exists, if not try comma
        if 'Class' not in reader.fieldnames:
             f = io.StringIO(content)
             reader = csv.DictReader(f, delimiter=',')
        
        if 'Class' not in reader.fieldnames:
            print(f"Error: Could not find 'Class' column in {url}. Fieldnames: {reader.fieldnames}")
            # Try to infer if it's headerless or different
            return []

        for row in reader:
            label = row.get('Class', '').lower().strip()
            if label in ['hate', 'abusive']:
                bad_tweets.append(row.get('Tweet', ''))
                
    except Exception as e:
        print(f"Failed to process {url}: {e}")
        
    return bad_tweets

def clean_text(text):
    if not text: return ""
    # Remove user handles, links, and non-arabic punctuation roughly
    text = re.sub(r'http\S+', '', text) # links
    text = re.sub(r'@\S+', '', text)    # mentions
    text = re.sub(r'[^\w\s\u0600-\u06FF]', ' ', text) # Keep Arabic and whitespace
    return text.strip()

def extract_keywords(tweets):
    words = set()
    # Manual stop words (very basic)
    stop_words = {'في', 'من', 'على', 'لا', 'ما', 'يا', 'انت', 'انا', 'هو', 'هي', 'و', 'أو', 'عن', 'كان', 'مع', 'هذا'}
    
    for tweet in tweets:
        cleaned = clean_text(str(tweet))
        tokens = cleaned.split()
        for token in tokens:
            if len(token) > 3 and token not in stop_words: # Filter short words
                words.add(token)
    return list(words)

def generate_dart_file(words):
    print(f"Generating Dart file with {len(words)} words...")
    content = "class GeneratedBannedWords {\n"
    content += "  static const List<String> list = [\n"
    for word in words:
        # Escape single quotes and backslashes
        safe_word = word.replace("\\", "\\\\").replace("'", "\\'")
        content += f"    '{safe_word}',\n"
    content += "  ];\n"
    content += "}\n"
    
    with open(OUTPUT_DART_FILE, "w", encoding="utf-8") as f:
        f.write(content)
    print(f"Done! Saved to {OUTPUT_DART_FILE}")

if __name__ == "__main__":
    all_tweets = []
    all_tweets.extend(download_and_parse_lhsab(LHSAB_TRAIN))
    all_tweets.extend(download_and_parse_lhsab(LHSAB_TEST))
    
    print(f"Total bad tweets found: {len(all_tweets)}")
    
    if not all_tweets:
        print("No tweets found. Checking logic.")
    
    unique_words = extract_keywords(all_tweets)
    
    # Sort for consistency
    unique_words.sort()
    
    generate_dart_file(unique_words)
