-- İngilizce çeviri tamamlandı (content/en/spring-batch.md) -- TR ile aynı
-- yapı (17/17 başlık, 4/4 embed). Yayına alınıyor. Bu, kullanıcının
-- orijinal "Scheduling and Batch Jobs" fikrinin ikinci ve son parçası --
-- Advanced Spring kategorisi artık 4 topic içeriyor (java-bean-validation,
-- exception-handling, task-execution-and-scheduling, spring-batch).
UPDATE topic_translation
SET published = true
WHERE language = 'en'
  AND topic_id = (SELECT id FROM topic WHERE slug = 'spring-batch');
