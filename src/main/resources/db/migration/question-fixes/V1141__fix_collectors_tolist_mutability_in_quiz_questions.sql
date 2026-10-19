-- İki quiz sorusu çifti, Collectors.toList()'in değiştirilebilir (mutable) bir liste
-- döndürdüğünü garanti ediyormuş gibi anlatıyordu. Java API dokümantasyonu döndürülen
-- listenin türü ve değiştirilebilirliği hakkında hiçbir garanti vermez (collectors dersinin
-- metni ve ToListToSetExample.java aynı nedenle düzeltildi, bkz. V1140).
--
-- (1) collectors, Pair 1 (EN + TR, CODE_OUTPUT, BEGINNER): question-promotion/V647 ekledi,
--     V649/V650 aynı satırı slug + dil + soru metni + kod ile bulup quiz'e bağladı (satır bir
--     kez var). Kod collect(Collectors.toList())'in sonucuna add() çağırıyordu; artık
--     Collectors.toCollection(ArrayList::new) kullanıyor, böylece beklenen çıktı ([1, 2, 3, 4] /
--     [x, y, z]) sözleşmeyle garanti. Şıklar ve doğru cevap DEĞİŞMEZ; açıklama yeni koda
--     göre yazılır.
-- (2) terminal-operations, Pair 6 (EN + TR, CODE_OUTPUT): question-promotion/V643 ekledi,
--     V645/V646 bağladı. Soru kodu (Stream.toList() + add()) ve şıklar doğru; yalnızca
--     açıklamadaki "Collectors.toList() mutable'dır" iması düzeltilir.
--
-- Yalnızca UPDATE: id, status, kaynak, quiz_question_link ve question_option satırları
-- korunur. Satırlar ortama özgü id ile değil, topic slug + dil + tip + ESKİ içerikle
-- bulunur; eski içerik değiştikten sonra artık eşleşmediği için tekrar çalıştırılması
-- hiçbir satırı değiştirmez.

-- (1a) collectors, EN
UPDATE question
SET code_snippet = $$import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

public class Demo {
    public static void main(String[] args) {
        List<Integer> nums = List.of(1, 2, 3).stream().collect(Collectors.toCollection(ArrayList::new));
        nums.add(4);
        System.out.println(nums);
    }
}$$,
    explanation = $$Collectors.toCollection(ArrayList::new) guarantees a mutable ArrayList, so add() works fine. Collectors.toList() would make no guarantee about mutability, and Stream.toList() would throw UnsupportedOperationException.$$,
    updated_at = now()
WHERE topic_id = (SELECT id FROM topic WHERE slug = 'collectors')
  AND language = 'en'
  AND type = 'CODE_OUTPUT'
  AND code_snippet = $$import java.util.List;
import java.util.stream.Collectors;

public class Demo {
    public static void main(String[] args) {
        List<Integer> nums = List.of(1, 2, 3).stream().collect(Collectors.toList());
        nums.add(4);
        System.out.println(nums);
    }
}$$;

-- (1b) collectors, TR
UPDATE question
SET code_snippet = $$import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

public class Ornek {
    public static void main(String[] args) {
        List<String> harfler = List.of("x", "y").stream().collect(Collectors.toCollection(ArrayList::new));
        harfler.add("z");
        System.out.println(harfler);
    }
}$$,
    explanation = $$Collectors.toCollection(ArrayList::new) değiştirilebilir (mutable) bir ArrayList garanti eder, bu yüzden add() sorunsuz çalışır. Collectors.toList() değiştirilebilirlik konusunda hiçbir garanti vermez, Stream.toList() ise UnsupportedOperationException fırlatırdı.$$,
    updated_at = now()
WHERE topic_id = (SELECT id FROM topic WHERE slug = 'collectors')
  AND language = 'tr'
  AND type = 'CODE_OUTPUT'
  AND code_snippet = $$import java.util.List;
import java.util.stream.Collectors;

public class Ornek {
    public static void main(String[] args) {
        List<String> harfler = List.of("x", "y").stream().collect(Collectors.toList());
        harfler.add("z");
        System.out.println(harfler);
    }
}$$;

-- (2a) terminal-operations, EN
UPDATE question
SET explanation = $$Stream.toList() returns an unmodifiable list, so calling add() on it throws UnsupportedOperationException. By contrast, collect(Collectors.toList()) makes no guarantee about mutability -- use Collectors.toCollection(ArrayList::new) when you need a list you can modify.$$,
    updated_at = now()
WHERE topic_id = (SELECT id FROM topic WHERE slug = 'terminal-operations')
  AND language = 'en'
  AND type = 'CODE_OUTPUT'
  AND explanation = $$Stream.toList() returns an unmodifiable list -- unlike collect(Collectors.toList()), which is mutable. Calling add() on it throws UnsupportedOperationException.$$;

-- (2b) terminal-operations, TR
UPDATE question
SET explanation = $$Stream.toList() değiştirilemez (unmodifiable) bir liste döner; üzerinde add() çağırmak UnsupportedOperationException fırlatır. collect(Collectors.toList()) ise değiştirilebilirlik konusunda hiçbir garanti vermez -- değiştirebileceğiniz bir liste gerekiyorsa Collectors.toCollection(ArrayList::new) kullanın.$$,
    updated_at = now()
WHERE topic_id = (SELECT id FROM topic WHERE slug = 'terminal-operations')
  AND language = 'tr'
  AND type = 'CODE_OUTPUT'
  AND explanation = $$Stream.toList(), collect(Collectors.toList())'in aksine, değiştirilemez (unmodifiable) bir liste döner. Üzerinde add() çağırmak UnsupportedOperationException fırlatır.$$;
