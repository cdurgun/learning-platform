-- Faz 82: "claude-code-cli-commands" konusunun topic_translation kayitlari.
-- TR yayinda, EN published=false (Faz 79-81'deki ayni desen -- ceviri
-- incelemesi bitince ayri bir migration'la yayina alinacak).

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id, 'tr', 'Claude Code CLI: Komutlar ve Kullanım',
       'Terminali kapatıp geri dönmekten context yönetimine, izin modlarından komut keşfetmeye: Claude Code CLI''ını günlük kullanımda etkin kullanmak için hızlı bir başvuru kaynağı -- resmi dokümantasyon ve gerçek bir CLI oturumuyla doğrulanmış.',
       'Claude Code CLI: Komutlar ve Kullanım — AI Development Tools',
       'Claude Code CLI''da session yönetimi (--continue, --resume, /resume), context yönetimi (/compact, /clear), izin modları ve Plan Mode''u -- resmi dokümantasyon ve gerçek bir CLI oturumuyla doğrulanmış örneklerle öğrenin.',
       true
FROM topic
WHERE slug = 'claude-code-cli-commands';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id, 'en', 'Claude Code CLI: Commands and Workflows',
       'From closing the terminal and coming back, to managing context, to controlling permission modes and discovering commands: a quick reference for using the Claude Code CLI effectively day to day -- verified against official documentation and a real CLI session.',
       'Claude Code CLI: Commands and Workflows — AI Development Tools',
       'Learn session management (--continue, --resume, /resume), context management (/compact, /clear), permission modes, and Plan Mode in the Claude Code CLI -- verified against official docs and a real CLI session.',
       false
FROM topic
WHERE slug = 'claude-code-cli-commands';
