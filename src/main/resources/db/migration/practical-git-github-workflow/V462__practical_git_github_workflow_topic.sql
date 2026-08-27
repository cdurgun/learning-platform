-- Advanced Git kategorisinin 5. (ve kursun SON) topic'i: "practical-git-github-
-- workflow". Kullanıcının açık talimatı gereği kursu, kursun TAMAMINDA öğretilen
-- her şeyi tek, gerçekçi bir uçtan uca senaryoda birleştiren pratik bir kapanış
-- dersiyle bitiriyor (clone -> feature branch -> commit/amend -> push -> PR ->
-- review feedback -> rebase onto main -> conflict çözümü -> force-with-lease ->
-- squash and merge -> branch temizliği). Bu topic BİLİNÇLİ OLARAK standart
-- "Common Mistakes/Best Practices/Cheat Sheet/Terimler Sözlüğü" şablonundan
-- SAPIYOR -- yeni kavram öğretmiyor, zaten öğretilenleri sentezliyor, bu yüzden
-- "Key Takeaways" ile kapanıyor. INTERMEDIATE/30dk, sort_order=5.

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'practical-git-github-workflow', 'INTERMEDIATE', 30, 5
FROM category
WHERE slug = 'advanced-git';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Practical Git & GitHub Workflow',
       'Kursun tamamında öğretilen her şeyi tek, gerçekçi bir uçtan uca Spring Boot senaryosunda birleştiren kapanış dersi: clone, feature branch, commit/amend, push, Pull Request, inceleme geri bildirimi, main üzerine rebase, conflict çözümü, force-with-lease, ve squash and merge.',
       'Uçtan Uca Gerçekçi Bir Git & GitHub Workflow''u',
       'Bir Java/Spring Boot özelliğinin clone''lamadan Pull Request''in squash-and-merge ile tamamlanmasına kadar tam yaşam döngüsü -- gerçekçi bir senaryoyla anlatılıyor.',
       true
FROM topic
WHERE slug = 'practical-git-github-workflow';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Practical Git & GitHub Workflow',
       'A closing lesson that ties together everything taught across the course in one continuous, realistic Spring Boot scenario: clone, feature branch, commit/amend, push, Pull Request, review feedback, rebasing onto main, resolving a conflict, force-with-lease, and squash and merge.',
       'A Realistic End-to-End Git & GitHub Workflow',
       'The full lifecycle of a Java/Spring Boot feature, from cloning to a Pull Request completed with squash-and-merge -- explained with a realistic scenario.',
       false
FROM topic
WHERE slug = 'practical-git-github-workflow';
