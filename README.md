# 🛡️ Kashef | كاشف

<div align="center">
  <img src="assets/images/logo.png" alt="Kashef Logo" width="120" height="120">
  <br>
  <h3><b>The AI-Powered Digital Shield for Syrian Content</b></h3>
  <h3><b>درعك الرقمي الذكي لحماية المحتوى السوري</b></h3>
</div>

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter)
![Python](https://img.shields.io/badge/Data_Factory-Python_3.9+-3776AB?style=for-the-badge&logo=python)
![Privacy](https://img.shields.io/badge/Privacy-RAM_Only-green?style=for-the-badge)
![AI](https://img.shields.io/badge/AI-Llama3_%2B_Groq-purple?style=for-the-badge)
![License](https://img.shields.io/badge/License-MIT-blue?style=for-the-badge)

</div>

---

## 📖 About The Project | عن المشروع

**[English]**
**Kashef** is not just a spell-checker; it is a specialized **AI-driven Compliance Engine** designed specifically for the Syrian digital landscape. In an era of aggressive algorithmic censorship, Syrian users often face unjust bans for using common dialect terms or reporting news. Kashef acts as a pre-posting filter, using a **Hybrid AI Architecture** to distinguish between harmful content (Strict Ban) and innocent context (Reporting/News).

> **Mission:** To protect the digital expression of Syrians from algorithmic bias by providing a smart tool that differentiates between "violating content" and "contextual speech."

**[العربية]**
**كاشف** ليس مجرد مدقق إملائي؛ إنه **محرك توافق مدعوم بالذكاء الاصطناعي** مصمم خصيصاً للمشهد الرقمي السوري. في عصر الرقابة الخوارزمية الشديدة، يواجه المستخدمون السوريون حظراً غير عادل بسبب استخدام مصطلحات عامية شائعة أو نقل الأخبار. يعمل كاشف كفلتر ما قبل النشر، مستخدماً **بنية ذكاء اصطناعي هجينة** للتمييز بين المحتوى الضار (حظر صارم) والسياق البريء (نقل أخبار/تقارير).

> **الرسالة:** حماية حرية التعبير الرقمي للسوريين من الانحياز الخوارزمي، عبر توفير أداة ذكية تميز بين "المحتوى المخالف" و"سياق الكلام".

---

## ✨ Key Features | المزايا الرئيسية

| Feature | Description | الميزة | الوصف |
| :--- | :--- | :--- | :--- |
| **🛡️ Hybrid AI Core** | Combines an instant, offline **Local Filter** (Layer 1) with advanced **Cloud AI** (Layer 2) for contextual understanding. | **نواة ذكاء اصطناعي هجين** | تجمع بين **فلتر محلي** فوري (طبقة 1) و **ذكاء اصطناعي سحابي** متقدم (طبقة 2) لفهم السياق. |
| **👻 Data Amnesia** | **Privacy by Design.** Analyzed text and results are stored in RAM only and vanish instantly when the app is closed. No history, no traces. | **فقدان الذاكرة للبيانات** | **الخصوصية من التصميم.** يتم تخزين النصوص المحللة والنتائج في الذاكرة المؤقتة (RAM) فقط وتختفي فور إغلاق التطبيق. لا سجل، لا آثار. |
| **🇸🇾 Syrian-Specialized** | Trained on a massive dataset of Syrian slang, political terms, and social context, including variations and Arabizi. | **متخصص بالشأن السوري** | مدرب على مجموعة بيانات ضخمة من العامية السورية، المصطلحات السياسية، والسياق الاجتماعي، بما في ذلك الاشتقاقات والـ Arabizi. |
| **⚡ Real-time Analysis** | Provides instant feedback on your text severity as you type. | **تحليل في الوقت الفعلي** | يوفر تغذية راجعة فورية حول خطورة النص أثناء الكتابة. |

---

## 🏗️ System Architecture | المعمارية التقنية

**[English]**
Kashef utilizes a **Dual-Layer Analysis System** to balance speed, privacy, and accuracy.

**[العربية]**
يستخدم كاشف **نظام تحليل ثنائي الطبقة** للموازنة بين السرعة، الخصوصية، والدقة.

```mermaid
graph TD
    User[User Input / مدخلات المستخدم] -->|Layer 1: Milliseconds| LocalFilter{Local Engine / المحرك المحلي}
    LocalFilter -->|Strict Term Detected / مصطلح صارم| Block[🔴 Block Immediately / حظر فوري]
    LocalFilter -->|Safe or Contextual / آمن أو سياقي| CloudAI{Layer 2: Cloud AI / الذكاء السحابي}
    
    subgraph "On-Device (Offline) / على الجهاز (دون اتصال)"
    LocalFilter
    Block
    end
    
    subgraph "Secure Cloud (Groq/Llama) / سحابة آمنة"
    CloudAI -->|Context Analysis / تحليل السياق| Decision[🟢 Safe or 🟡 Warning / آمن أو تحذير]
    end
    
    Decision --> UI[Display Result / عرض النتيجة]

```

---

## 🏭 The Data Factory (Behind the Scenes) | مصنع البيانات (خلف الكواليس)

**[English]**
What makes Kashef unique is its backend **Data Factory** located in `tools/data_factory/`. This Python pipeline engineers the blocklist instead of just guessing words.

* **Policy Extraction:** Uses AI to reverse-engineer official Community Standards from platforms like Facebook & X.
* **Nuclear Injection:** Starts with a massive seed of 300+ base Syrian terms.
* **Local LLM Expansion:** Utilizes a local **Ollama (Llama 3)** instance to generate thousands of morphological variations and classify them as `STRICT` or `CONTEXTUAL`.

**[العربية]**
ما يميز كاشف هو **مصنع البيانات** الخلفي الموجود في `tools/data_factory/`. هذا المسار البرمجي (Python pipeline) يقوم بهندسة قائمة الحظر بدلاً من مجرد تخمين الكلمات.

* **استخراج السياسات:** يستخدم الذكاء الاصطناعي للهندسة العكسية لمعايير المجتمع الرسمية من منصات مثل فيسبوك و X.
* **الحقن النووي:** يبدأ ببذرة ضخمة تحتوي على أكثر من 300 مصطلح سوري أساسي.
* **التوسع المحلي (LLM):** يستخدم مثيل **Ollama (Llama 3)** محلي لتوليد آلاف الاشتقاقات الصرفية وتصنيفها كـ `صارمة` أو `سياقية`.

---

## 🚀 Getting Started |เริ่มต้นใช้งาน

### Prerequisites | المتطلبات الأساسية

* Flutter SDK `3.x`
* Dart `3.x`
* An API Key from [Groq](https://groq.com/) (for Cloud Analysis).

### Installation | التثبيت

1. **Clone the Repository | استنسخ المستودع**
```bash
git clone https://github.com/yourusername/kashef.git
cd kashef

```


2. **Secure Setup | الإعداد الآمن**
Create a `.env` file in the root directory and add your Groq API Key. **Do not commit this file.**
أنشئ ملف `.env` في المجلد الجذري وأضف مفتاح Groq API الخاص بك. **لا تقم برفع هذا الملف.**
```env
GROQ_API_KEY=your_api_key_here

```


3. **Run the App | تشغيل التطبيق**
```bash
flutter pub get
flutter run

```


4. **Production Build (Obfuscated) | بناء النسخة النهائية (المشوشة)**
To protect the codebase and wordlist from reverse engineering:
لحماية الكود وقائمة الكلمات من الهندسة العكسية:
```bash
flutter build apk --obfuscate --split-debug-info=./debug-info --release

```



---

## 🔒 Security & Privacy | الأمن والخصوصية

**[English]**
Security is paramount for Kashef. We have implemented multiple layers of protection:

* **API Protection:** Keys are stored securely in `.env` and never hardcoded.
* **Code Obfuscation:** Production builds are obfuscated to prevent decompilation and theft of the blocklist.
* **Minimal Permissions:** The app requests only essential permissions (Internet). No access to location, microphone, or contacts.
* **Secure Network:** Forces HTTPS for all network traffic.

**[العربية]**
الأمن هو الأولوية القصوى لكاشف. لقد قمنا بتنفيذ طبقات متعددة من الحماية:

* **حماية API:** يتم تخزين المفاتيح بشكل آمن في `.env` ولا يتم كتابتها في الكود مباشرة أبداً.
* **تشويش الكود:** يتم تشويش النسخ النهائية لمنع فك التجميع وسرقة قائمة الحظر.
* **صلاحيات دنيا:** يطلب التطبيق الصلاحيات الأساسية فقط (الإنترنت). لا وصول للموقع، الميكروفون، أو جهات الاتصال.
* **شبكة آمنة:** يفرض استخدام HTTPS لجميع حركات الشبكة.

---

## 📸 Screenshots | لقطات الشاشة

| Home Scanner / فاحص الرئيسية | Real-time Analysis / تحليل فوري | Settings & Privacy / الإعدادات والخصوصية |
| --- | --- | --- |
| <img src="assets/screenshots/home.png" alt="Home Screen" width="200"/> | <img src="assets/screenshots/analysis.png" alt="Analysis Result" width="200"/> | <img src="assets/screenshots/settings.png" alt="Settings Screen" width="200"/> |

*(Note: Please update the `assets/screenshots/` folder with actual app screenshots.)*
*(ملاحظة: يرجى تحديث مجلد `assets/screenshots/` بلقطات شاشة حقيقية للتطبيق.)*

---

## 🤝 Contributing | المساهمة

**[English]**
Contributions are welcome! If you want to improve the Syrian Slang Dataset, please submit a Pull Request to the `tools/data_factory/` directory.

**[العربية]**
المساهمات مرحب بها! إذا كنت ترغب في تحسين مجموعة بيانات العامية السورية، يرجى تقديم طلب سحب (Pull Request) إلى مجلد `tools/data_factory/`.

---

---

## ❤️ Support Kashef | ادعم كاشف

**[English]**
This platform is **Free & Open Source**. Your support helps keep the servers running and the AI models updated.
If you find this tool useful, consider donating to the ongoing development:

| Currency | Address |
| :--- | :--- |
| **Bitcoin (BTC)** | `bc1p42akn5et2kuexnlmtyhhkv2rgngp85rzydww0zh2w9cc3rj86xhqfemhhe` |
| **Ethereum (ETH)** | `0xb15af72fd8e0dd098158b0251d43f9a272b6505d` |
| **Solana (SOL)** | `ANE9Sh9Y2ExSofj9wsR7vkxKKNuawSH9KtpztxEFXs3K` |

**[العربية]**
هذه المنصة **مجانية ومفتوحة المصدر**. دعمك يساعد في استمرار عمل السيرفرات وتحديث نماذج الذكاء الاصطناعي.
إذا وجدت هذه الأداة مفيدة، يرجى التفكير في التبرع لاستمرار التطوير:

| العملة | العنوان |
| :--- | :--- |
| **Bitcoin (BTC)** | `bc1p42akn5et2kuexnlmtyhhkv2rgngp85rzydww0zh2w9cc3rj86xhqfemhhe` |
| **Ethereum (ETH)** | `0xb15af72fd8e0dd098158b0251d43f9a272b6505d` |
| **Solana (SOL)** | `ANE9Sh9Y2ExSofj9wsR7vkxKKNuawSH9KtpztxEFXs3K` |

---

## 📄 License | الترخيص

This project is licensed under the **MIT License** - see the [LICENSE](https://www.google.com/search?q=LICENSE) file for details.
هذا المشروع مرخص بموجب **رخصة MIT** - راجع ملف [LICENSE](https://www.google.com/search?q=LICENSE) للتفاصيل.

---

## 👨‍💻 Meet the Creator | المطور

<div align="center">

<img src="assets/team/obada_dallo.jpg" alt="Obada Dallo" width="150" style="border-radius: 50%; border: 4px solid #0D47A1;">

### **Obada Dallo | عبادة دللو**
**Founder & Lead Developer**
*"Building digital shields for a safer internet."*

[![GitHub](https://img.shields.io/badge/GitHub-100000?style=for-the-badge&logo=github&logoColor=white)](https://github.com/obadadallo95)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/obada-dallo-777a47a9/)
[![Facebook](https://img.shields.io/badge/Facebook-1877F2?style=for-the-badge&logo=facebook&logoColor=white)](https://www.facebook.com/obada.dallo33)
[![Telegram](https://img.shields.io/badge/Telegram-2CA5E0?style=for-the-badge&logo=telegram&logoColor=white)](https://t.me/obada_dallo95)
[![Email](https://img.shields.io/badge/Email-D14836?style=for-the-badge&logo=gmail&logoColor=white)](mailto:obada.dallo95@gmail.com)

</div>

---

<div align="center">
<p>Made with ❤️ and 🛡️ for a safer digital space.</p>
<p>صُنع بـ ❤️ و 🛡️ من أجل فضاء رقمي أكثر أماناً.</p>
</div>
