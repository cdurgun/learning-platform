---
name: quiz-questions
description: LearnForgeX'te bir konuya "Test Your Knowledge" quiz soruları yazar ve migration'larını üretir — EN/TR kavram çiftleri, tip ve zorluk seçimi, şık sırası, promote + quiz shell + link migration'ları. "X konusuna quiz ekle", "quiz soruları yaz", "quiz'i eksik konular" denildiğinde kullan.
---

# quiz-questions

Bir konunun sabit quiz'ine soru yazar. Sorular bu oturumda elle yazılır (n8n/OpenAI hattı ayrı
bir alternatiftir, bu skill onu kullanmaz). SQL elle yazılmaz: sorular bir JSON tanım dosyasına
(spec) yazılır, `build_quiz.py` onu denetler ve migration'lara çevirir.

## Akış

1. **Kapsamı belirle.** Tek konu, tek spec. Konunun quiz'i ya da havuzda sorusu var mı bak;
   varsa yeni sorular mevcutlara eklenir (script pozisyonu ve batch numarasını kendisi bulur).
2. **Dersi oku:** `content/en/{slug}.md`, `content/tr/{slug}.md` ve gömülen örnek dosyalar.
   Sorular yalnızca dersin gerçekten anlattığına dayanır.
3. **Kavramları listele, çiftleri seç.** Dersin uzunluğuna ve kavram yoğunluğuna göre 4–7 çift.
4. **Spec'i yaz** — proje içine değil, geçici dizine (scratchpad).
5. **Denetle:** `python3 .claude/skills/quiz-questions/build_quiz.py check SPEC.json`.
   Hata ve uyarı sıfır olmalı. `check`, Java kod çıktısı sorularını gerçekten derleyip
   çalıştırır (birkaç saniye sürer).
6. **Kavram eşleşmesini gözle doğrula.** `preview` çıktısında her çift için "EN sorusu neyi
   ölçüyor, TR sorusu neyi ölçüyor" diye kendine sor; ikisi aynı kavram olmalı. Script
   yalnızca ikisinin aynı bölüme bağlandığını doğrulayabilir, anlamı doğrulayamaz.
7. **Kullanıcıya göster ve onay al.** `preview` çıktısını (şıkların nihai sırasıyla) sun.
   Onay gelmeden migration üretme.
8. **Üret:** `... build_quiz.py generate SPEC.json` (önce `--dry-run` ile dosya adlarına bak).
9. **Doğrula:**
   - `JAVA_HOME=/Library/Java/JavaVirtualMachines/temurin-21.jdk/Contents/Home mvn -q test`
     — migration'ları temiz `learning_test` veritabanına uygular. Bu makinede Maven
     varsayılan JDK'sı (26) Lombok'u kırar, JDK 21 şart.
   - Soru ve bağlantı sayılarını `learning_test`'te SQL ile say (dil başına çift sayısı kadar).
   - `CONTENT_CHECK_PSQL="docker exec learning-platform-db psql -U learning -d learning_test" python3 .claude/skills/content-check/check_content.py --slug {slug}`
     — quiz metnindeki bölüm atıflarını denetler. Dev veritabanı, uygulama bir kez
     başlatılana kadar yeni migration'ı görmez; bu yüzden test veritabanına karşı çalıştır.
10. **Raporla.** Commit ve `docs/phase-log.md` kullanıcı isteyince.

## Spec biçimi

```json
{
  "topic": "if-else",
  "pairs": [
    {
      "concept": "bu çiftin ölçtüğü kavram, tek cümle",
      "section": { "en": "else if Chains", "tr": "else if Zinciri" },
      "type": "CODE_OUTPUT",
      "difficulty": "BEGINNER",
      "en": {
        "question": "...",
        "code": "int x = 1;\nSystem.out.println(x);",
        "codeLanguage": "java",
        "expectedOutput": "1",
        "explanation": "...",
        "correct": ["..."],
        "wrong": ["...", "...", "..."]
      },
      "tr": { "...": "aynı alanlar" }
    }
  ]
}
```

- `type`, `difficulty`, `concept` ve `section` çift düzeyindedir (EN ve TR için ortak).
- `section`: çiftin dayandığı bölümün iki dildeki H2 başlığı, birebir. Script ikisinin de
  derste var olduğunu ve aynı sıradaki bölüm olduğunu doğrular; EN ve TR sorusunun aynı
  kavramı sorduğunun mekanik güvencesi budur.
- `correct` + `wrong` toplam 4 şıktır. `code`, `codeLanguage`, `expectedOutput` yalnızca
  `CODE_OUTPUT`'ta kullanılır; diğer tiplerde yazılmaz.
- Şıkların sırasını yazar belirlemez. Script doğru şıkların konumunu A–D arasında dengeli
  dağıtmaya çalışır. Bu yumuşak bir hedeftir: dengesizlik bilgi olarak raporlanır, üretimi
  durdurmaz.

### Kod çıktısı doğrulaması

`check`, `codeLanguage: "java"` olan her `CODE_OUTPUT` sorusunun kodunu JDK 21 ile gerçekten
derleyip çalıştırır ve üç şeyi karşılaştırır: gerçek çıktı `expectedOutput` ile aynı mı, gerçek
çıktının her satırı doğru şıkta geçiyor mu, yanlış şıklardan biri gerçek çıktıyla aynı mı.

- Kod bir sınıf içermiyorsa script onu `throws` içermeyen bir `main` metoduna sarar; sınıf
  içeriyorsa olduğu gibi derler. Checked exception fırlatan kod (`join()`, `sleep()`, dosya
  işlemleri) bu yüzden parça olarak derlenmez: `throws` ya da `try`/`catch` içeren tam bir sınıf
  olarak yazılmalıdır, çünkü okuyucunun gördüğü kod da kendi başına derlenebilir olmalıdır.
- Beklenen sonuç çıktı değilse `"expect": "compile-error"` ya da `"expect": "exception"` yaz.
  `exception` için `expectedException` (ör. `"NullPointerException"`) zorunludur; `expectedOutput`
  o noktaya kadar yazdırılan çıktıdır ve doğru şık exception'ın adını içermelidir.
- Java dışındaki diller (bash, sql, jsx...) otomatik çalıştırılmaz. Bunlarda
  `manualVerification` alanına çıktının nasıl doğrulandığını yaz (ör. gerçek terminal çıktısı);
  alan boşsa `check` hata verir. Çıktıyı doğrulayamıyorsan o soruyu yazma.
- JDK bulunamazsa `QUIZ_JAVA_HOME` ile gösterilir.

## Yazım kuralları

**Çiftler**
- Her çift bir kavramdır; EN ve TR sorusu aynı kavramı ölçer ama birbirinin çevirisi değildir:
  farklı senaryo, farklı şıklar, farklı örnek.
- Bir batch'te en fazla bir tanım sorusu ("X nedir?"). Gerisi uygulama, sonuç tahmini, hata
  bulma, doğru yaklaşımı seçme.
- Aynı cümle kalıbını tekrar etme ("Bu derse göre..." ile başlayan altı soru olmasın).

**Tipler**
- `SINGLE_CHOICE` çoğunluktur; tam 1 doğru.
- `MULTIPLE_CHOICE` tam 2 doğru; soru metni birden fazla seçilebileceğini söyler. Puanlama kısmi
  doğruyu kabul etmez.
- `CODE_OUTPUT` yalnızca cevap gösterilen kodun çıktısına/davranışına bağlıysa ve ders bu tür
  bir kodu gerçekten gösteriyorsa. Kod yalnızca `code` alanına yazılır, soru metnine değil.
  Tersi de kural: cevabı gösterilen koda bağlı bir soru `SINGLE_CHOICE` olamaz, çünkü `code`
  yalnızca `CODE_OUTPUT`'ta render edilir. Soru metninde kısa satır içi kod (`if (x)`) serbest.
- `CODE_OUTPUT` kodu kısa olsun. Çıktısı elle tahmin edilmez, `check` tarafından çalıştırılarak
  doğrulanır (bkz. "Kod çıktısı doğrulaması"). Cevabı bir koda dayanan ama `CODE_OUTPUT`
  olmayan bir iddia yazıyorsan ("şu satır derlenmez") onu da ayrıca çalıştırıp doğrula.

**Kesinlik**
- Dersin sadeleştirerek söylediği bir şeyi soruda mutlak bir iddiaya çevirme. "Her zaman",
  "yalnızca", "asla", "neredeyse hiç" içeren her şık ve soru için karşı örnek ara: bir
  exception'ın mesajı `null` olabilir; `for (;;)` bir exception'la da biter; bir race condition
  sonucu "çoğunlukla" değil "olabilir" diye ifade edilir.
- Belirli bir aracı (Babel, esbuild...) bir işin zorunlu ya da varsayılan mekanizması gibi sunma;
  ders öyle dese bile soruda mekanizmayı değil sonucu sor.

**Şıklar ve açıklama**
- Yanlış şıklar gerçekçi olsun: bir öğrencinin gerçekten düşebileceği yanılgılar. Bariz saçma
  şık yazma; "hepsi" / "hiçbiri" şıkkı kullanma.
- Doğru şık uzunluğuyla ya da ayrıntı düzeyiyle kendini ele vermesin.
- Açıklama doğru cevabın neden doğru olduğunu ve en yakın yanlış şıkkın neden yanlış olduğunu
  söyler.
- Soru, şık ve açıklama metninde şık harfine (A, B, C, D) atıf yasak: "A ve B doğrudur",
  "C şıkkı", "(D)". Arayüzde şıkların yanında harf yok, sıra da script'e ait. `check` bunu
  hata olarak yakalar. Atıf gerekiyorsa şıkkın içeriğini an ("referans karşılaştırması
  yapan ifade").

**Bölüm atıfları**
- Bir soru derse bölüm adıyla atıf yapıyorsa, o dildeki dersin H2 başlığını birebir kullanır:
  Türkçe soru Türkçe başlığı. İngilizce başlığa atıf yapan Türkçe soru bu projede 32 kez
  düzeltilmek zorunda kaldı. `check` bunu hata olarak yakalar.

**Zorluk**
- Konunun kendi zorluğu etrafında dağıt; her şeyi `BEGINNER` yapma.

## Script'in ürettiği dosyalar

Var olan konvansiyonla aynı: `question-promotion/V{n}__promote_questions_{slug}-batch-{k}.sql`,
gerekirse `{slug}/V{n+1}__{slug}_quiz_topic.sql` (quiz shell), ardından EN ve TR link
migration'ları. Shell yalnızca hiçbir migration'da yoksa üretilir: bazı kursların (ör. docker)
konu migration'ı shell'i zaten ekler, ikincisi `duplicate key` ile uygulamayı durdurur. Script
var olan bir dosyanın üzerine yazmaz ve üretilen SQL elle düzenlenmez — düzeltme gerekiyorsa
spec'i düzelt, dosyaları silip yeniden üret (yalnızca henüz commit edilmemişse; commit edilmiş
bir migration asla değiştirilmez).
