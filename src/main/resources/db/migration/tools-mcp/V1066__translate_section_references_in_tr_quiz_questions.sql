-- tools-and-function-calling, introduction-to-mcp ve mcp-architecture derslerinin Türkçe
-- sürümlerinde İngilizce kalmış bölüm başlıkları Türkçeleştirildi (content/tr/*.md).
-- Türkçe quiz sorularının metni/açıklaması bu başlıklara tırnak içinde atıf yapıyor;
-- bu migration o atıfları yeni başlıklarla eşitler. Soru id'lerine değil metne göre
-- eşleştiği için ortamdan bağımsızdır; tekrar çalıştırılması hiçbir şeyi değiştirmez.
UPDATE question
SET question = replace(replace(replace(replace(replace(question,
        '''The Tool-Calling Loop''un', '''Tool-Calling Döngüsü''nün'),
        '''The Tool-Calling Loop''', '''Tool-Calling Döngüsü'''),
        '''Tool Use vs. Agents''', '''Tool Use ve Agent Karşılaştırması'''),
        '''Defining a Tool: Name, Description, and Schema''', '''Bir Tool Tanımlamak: Ad, Açıklama ve Şema'''),
        '''Why Does It Exist?''', '''Neden Var?'''),
    explanation = replace(replace(replace(replace(replace(explanation,
        '''The Tool-Calling Loop''un', '''Tool-Calling Döngüsü''nün'),
        '''The Tool-Calling Loop''', '''Tool-Calling Döngüsü'''),
        '''Tool Use vs. Agents''', '''Tool Use ve Agent Karşılaştırması'''),
        '''Defining a Tool: Name, Description, and Schema''', '''Bir Tool Tanımlamak: Ad, Açıklama ve Şema'''),
        '''Why Does It Exist?''', '''Neden Var?''')
WHERE language = 'tr'
  AND (question || ' ' || explanation) ~
      '(The Tool-Calling Loop|Tool Use vs\. Agents|Defining a Tool: Name, Description, and Schema|Why Does It Exist\?)';
