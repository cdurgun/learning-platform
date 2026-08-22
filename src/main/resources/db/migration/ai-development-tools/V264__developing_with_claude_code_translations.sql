-- Faz 81: "developing-with-claude-code" konusunun topic_translation
-- kayitlari. TR yayinda, EN published=false (Faz 79-80'deki ayni desen --
-- ceviri incelemesi bitince ayri bir migration'la yayina alinacak).

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id, 'tr', 'Claude Code ile AI Destekli Yazılım Geliştirme',
       'Gerçek bir Spring Boot özelliğini, gerçek bir Claude Code terminal oturumunda analiz edip planlayın, uygulayın, test edin ve gözden geçirin: Plan Mode, izin modeli, ve gerçekten yakalanmış hatalarla.',
       'Claude Code ile AI Destekli Yazılım Geliştirme — AI Development Tools',
       'Claude Code CLI ile gerçek bir Spring Boot özelliğini analiz edin, Plan Mode''da planlayın, dosya dosya onaylayarak uygulayın, test edin, gözden geçirin ve commit edin.',
       true
FROM topic
WHERE slug = 'developing-with-claude-code';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id, 'en', 'AI-Assisted Software Development with Claude Code',
       'Analyze, plan, implement, test, and review a real Spring Boot feature in a real Claude Code terminal session: Plan Mode, the permission model, and bugs actually caught along the way.',
       'AI-Assisted Software Development with Claude Code — AI Development Tools',
       'Analyze a real Spring Boot feature with the Claude Code CLI, plan it in Plan Mode, implement it with file-by-file approval, test it, review it, and commit it.',
       false
FROM topic
WHERE slug = 'developing-with-claude-code';
