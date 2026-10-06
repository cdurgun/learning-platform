package com.cdurgun.learning.service;

import com.cdurgun.learning.domain.Category;
import com.cdurgun.learning.domain.Course;
import com.cdurgun.learning.domain.Language;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Service;

import java.util.Locale;

/**
 * Kurs ve kategori adlarının dile göre görünen hâli. Yeni bir çeviri tablosu yok:
 * {@code QuizNavigationService}'in quiz adları için zaten kullandığı yaklaşımın aynısı --
 * slug ile anahtarlanan mesajlar ({@code course.{slug}.name}, {@code category.{slug}.name}),
 * mesaj yoksa veritabanındaki ad. Böylece adı henüz çevrilmemiş yeni bir kurs/kategori
 * bozuk bir anahtar yerine kendi DB adıyla görünür.
 *
 * <p>Slug'lar ve URL'ler bu sınıftan etkilenmez; yalnızca ekranda ve yapılandırılmış
 * veride gösterilen ad değişir. Kategori slug'ları kurslar arasında da benzersizdir, bu
 * yüzden anahtarda kurs slug'ı yer almaz.</p>
 */
@Service
public class CatalogNames {

    private final MessageSource messageSource;

    public CatalogNames(MessageSource messageSource) {
        this.messageSource = messageSource;
    }

    public String course(Course course, Language language) {
        return messageSource.getMessage("course." + course.getSlug() + ".name", null, course.getName(), locale(language));
    }

    public String category(Category category, Language language) {
        return messageSource.getMessage("category." + category.getSlug() + ".name", null, category.getName(), locale(language));
    }

    private static Locale locale(Language language) {
        return Locale.forLanguageTag(language.getCode());
    }
}
