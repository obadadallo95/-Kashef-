import requests
import json
import time
from tqdm import tqdm
import config

class AIWordsGenerator:
    def __init__(self):
        self.url = config.OLLAMA_URL
        self.model = config.OLLAMA_MODEL

    def _call_ollama(self, prompt, retries=1):
        for attempt in range(retries + 1):
            try:
                response = requests.post(
                    self.url,
                    json={
                        "model": self.model,
                        "messages": [{"role": "user", "content": prompt}],
                        "format": "json",
                        "stream": False,
                        "options": {"temperature": 0.7}
                    },
                    timeout=300 # 5 minutes timeout
                )
                response.raise_for_status()
                content = response.json()['message']['content']
                return content
            except requests.exceptions.ConnectionError:
                print("❌ Error: Ollama is not running at localhost:11434.")
                raise ConnectionError("Ollama not reachable")
            except Exception as e:
                if attempt < retries:
                    print(f"   ⚠️ Error calling Ollama: {e}. Retrying...")
                    time.sleep(2)
                else:
                    print(f"   ❌ Failed after retries: {e}")
                    return "{}"

    def extract_policy_terms(self, platform, policy_name, context="Syrian"):
        prompt = (
            f"Act as a Trust & Safety Expert at {platform}.\n"
            f"Based on the '{policy_name}' policy, list 30 specific slang terms or keywords in {context} Arabic that would trigger a ban or flag.\n"
            f"Focus on: Hidden slang, code words, and indirect hate speech.\n"
            f"IMPORTANT: Output Must be in ARABIC. Do NOT include English words.\n"
            f"Output strictly JSON: {{'policy_terms': ['word1', 'word2']}}"
        )
        return self._call_ollama(prompt)

    def expand_database(self):
        print(f"🧠 [Step 2] Starting Smart AI Expansion & Classification (Ollama: {self.model})...")
        
        # Load Input
        try:
            with open(config.RAW_DATA_FILE, 'r', encoding='utf-8') as f:
                data = json.load(f)
                words = data['words']
        except FileNotFoundError:
            print(f"❌ Input file not found. Run collector first.")
            return

        # Key: word, Value: type (STRICT preferred if conflict)
        expanded_map = {} 
        
        batch_size = 10
        batches = [words[i:i + batch_size] for i in range(0, len(words), batch_size)]
        
        print(f"   Processing Syrian Dataset: {len(words)} words in {len(batches)} batches...")

        for batch in tqdm(batches):
            batch_str = ", ".join(batch)
            prompt = (
                f"You are a Safety Analyst for Syrian social media.\n"
                f"Task: Generate variations for these terms: [{batch_str}].\n\n"
                f"Instructions:\n"
                f"1. Generate 5-10 variations/slang/misspellings/morphologies for EACH term.\n"
                f"2. Strict Constraints: OUTPUT ARABIC ONLY. NO English words (e.g. no 'sassyslayers', no 'isis').\n"
                f"3. Classify EACH variation as:\n"
                f"   - 'STRICT': Only for illegal goods (drugs, weapons), extreme sexual violence, or severe slurs ('شرموطة', 'ديوث').\n"
                f"   - 'CONTEXTUAL': For Political Groups ('داعش', 'HTS'), Weapons, Violence keywords, and Controversial Symbols. "
                f"     Note: Political terms must be CONTEXTUAL because users might be condemning them (Journalist use-case).\n\n"
                "Output strictly JSON: {'variations': [{'word': 'عربي_فقط', 'type': 'STRICT'}, {'word': 'سلاح', 'type': 'CONTEXTUAL'}]}"
            )
            
            json_str = self._call_ollama(prompt)
            
            try:
                parsed = json.loads(json_str)
                items = []
                if 'variations' in parsed:
                    items = parsed['variations']
                elif isinstance(parsed, list):
                    items = parsed
                
                for item in items:
                    if isinstance(item, dict):
                        w = item.get('word', '').strip()
                        t = item.get('type', 'CONTEXTUAL').upper()
                        
                        # Filter out non-Arabic roughly (optional, but prompt should handle it)
                        # We allow numbers and spaces, but reject purely latin terms if needed.
                        # For now, trust the prompt but relying on the "NO English" instruction.
                        
                        if w:
                             # Strict takes precedence if a word was previously Contextual
                            if w in expanded_map:
                                if t == 'STRICT':
                                    expanded_map[w] = 'STRICT'
                            else:
                                expanded_map[w] = t
                    elif isinstance(item, str):
                        # Fallback for strings
                        if item not in expanded_map:
                            expanded_map[item] = 'CONTEXTUAL'

            except json.JSONDecodeError:
                pass

        # Ensure original words are also present.
        for w in words:
            if w not in expanded_map:
                expanded_map[w] = 'CONTEXTUAL'

        self._save_output(expanded_map)
        print(f"✅ Step 2 Complete. Database size: {len(expanded_map)} classified terms.")

    def _save_output(self, word_map):
        # Convert map back to list of objects
        output_list = [{"word": w, "type": t} for w, t in word_map.items()]
        
        final_data = {
            "metadata": {
                "source": "Kashef AI (Smart Policy Engine)",
                "model": self.model
            },
            "data": output_list
        }
        with open(config.EXPANDED_DATA_FILE, 'w', encoding='utf-8') as f:
            json.dump(final_data, f, ensure_ascii=False, indent=2)

if __name__ == "__main__":
    generator = AIWordsGenerator()
    generator.expand_database()
