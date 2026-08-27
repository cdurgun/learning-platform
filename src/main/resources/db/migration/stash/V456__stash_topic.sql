-- Advanced Git kategorisinin 3. topic'i: "stash". Odak: apply vs pop, çoklu/
-- isimlendirilmiş stash'ler, drop/clear, takip edilmeyen dosyalar, ve gerçekçi
-- bir "işi yarıda bırakıp başka bir göreve geçmek" senaryosu. Kullanıcının açık
-- talimatı gereği INTERMEDIATE/25dk, sort_order=3.

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'stash', 'INTERMEDIATE', 25, 3
FROM category
WHERE slug = 'advanced-git';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Stash',
       'git stash ile commit edilmemiş değişiklikleri bir kenara kaydetmek, apply vs pop farkı, çoklu ve isimlendirilmiş stash''ler, git stash drop/clear, ve takip edilmeyen dosyaları stash''lemek. Gerçekçi bir "işi yarıda bırakıp başka göreve geçmek" senaryosu.',
       'Git Stash: Commit Etmeden İşi Bir Kenara Koymak',
       'git stash nasıl kullanılır, apply ile pop arasındaki fark nedir, ve birden fazla stash nasıl yönetilir -- gerçekçi bir senaryoyla anlatılıyor.',
       true
FROM topic
WHERE slug = 'stash';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Stash',
       'Saving uncommitted changes aside with git stash, the difference between apply and pop, multiple and named stashes, git stash drop/clear, and stashing untracked files. A realistic "interrupted mid-feature, need to switch tasks" scenario.',
       'Git Stash: Setting Work Aside Without Committing',
       'How to use git stash, what the difference is between apply and pop, and how to manage multiple stashes -- explained with a realistic scenario.',
       false
FROM topic
WHERE slug = 'stash';
