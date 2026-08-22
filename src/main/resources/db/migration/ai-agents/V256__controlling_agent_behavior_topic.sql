-- Faz 80, Wave 4: "controlling-agent-behavior" konusunun topic_translation
-- kayıtları. TR yayında, EN published=false. Bir agent loop'unu gerçek bir
-- otonomiyle çalıştırmayı güvenli kılan pratik mekanizmaları kapsıyor: adım
-- sınırları, human-in-the-loop, en az yetki ilkesi, ve observability -- bir
-- sonraki (ve son) topic olan "Building an AI Agent in TypeScript"ın
-- uygulayacağı adım sınırı korkuluğunun kavramsal temeli.

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id, 'tr', 'Agent Davranışını Kontrol Etmek',
       'Bir agent loop''unu güvenli kılan korkuluklar: adım sınırları, human-in-the-loop onayı, en az yetki ilkesi, ve observability.',
       'Agent Davranışını Kontrol Etmek — AI Agents',
       'Agent korkuluklarını öğrenin: adım/iterasyon sınırları, human-in-the-loop, en az yetki ilkesi, ve observability.',
       true
FROM topic
WHERE slug = 'controlling-agent-behavior';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id, 'en', 'Controlling Agent Behavior',
       'The guardrails that make running an agent loop safe: step limits, human-in-the-loop approval, least privilege, and observability.',
       'Controlling Agent Behavior — AI Agents',
       'Learn agent guardrails: step/iteration limits, human-in-the-loop approval, the principle of least privilege, and observability.',
       false
FROM topic
WHERE slug = 'controlling-agent-behavior';
