import collector
import ai_generator
import cleaner
import time

def main():
    print("🏭 Kashef Smart Policy Engine (Local Ollama) 🏭")
    print("==================================================")
    
    start_time = time.time()

    # Step 1: Collection (Seeds + Policy Extraction)
    collector.run_collection()
    collector.collect_official_policies()
    
    # Step 2: AI Expansion & Smart Classification
    generator = ai_generator.AIWordsGenerator()
    generator.expand_database()

    # Step 3: Cleaning & Code Generation
    cleaner.clean_and_generate()

    elapsed = time.time() - start_time
    print(f"🎉 Pipeline Finished Successfully in {elapsed:.2f} seconds.")

if __name__ == "__main__":
    main()
