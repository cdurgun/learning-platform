package com.cdurgun.learning.web.quiz;

import java.util.List;

/**
 * POST /{lang}/practice/submit istek gövdesi. Her cevap AYNI {@link QuizAnswer}
 * şeklini kullanır (sabit quiz submit'iyle paylaşılıyor, yeni bir model
 * yaratılmadı) -- fark, sarmalayıcı seviyesindeki doğrulamada: burada bir
 * {@code Quiz}'in soru kümesine karşı TAM kapsama zorunluluğu YOK (bkz.
 * PracticeService.submit ve plan bölüm 5), çünkü çekilen practice seti hiçbir
 * yerde kalıcı olarak saklanmıyor -- cevaplanan her soru kendi başına doğrulanır.
 */
public record PracticeSubmitRequest(List<QuizAnswer> answers) {
}
