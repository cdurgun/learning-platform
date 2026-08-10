-- Spring IoC Container & Bean Lifecycle konusu, 1-8. örnekler (BeanFactory,
-- ApplicationContext, Spring Bean, Java Config ile Bean Tanımlama, Bean Adlandırma,
-- Bean Lifecycle Fazları, @PostConstruct/@PreDestroy, InitializingBean/DisposableBean)
-- için örnek metadata'sı. Dosyaların kendisi examples/spring-ioc-container/ altında.

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'BeanFactory: Kök Arayüz', 'BeanFactoryExample', 1
FROM topic WHERE slug = 'spring-ioc-container';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'ApplicationContext: Eager Singleton Yaratma', 'ApplicationContextExample', 2
FROM topic WHERE slug = 'spring-ioc-container';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Spring Bean Nedir? (getBean, containsBean)', 'SpringBeanBasicsExample', 3
FROM topic WHERE slug = 'spring-ioc-container';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Bean Tanımlama: @Bean ile Java Config', 'JavaConfigBeanExample', 4
FROM topic WHERE slug = 'spring-ioc-container';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Bean Adlandırma ve Birden Fazla Bean', 'MultipleBeansExample', 5
FROM topic WHERE slug = 'spring-ioc-container';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Bean Lifecycle Fazları (BeanPostProcessor ile)', 'BeanLifecyclePhasesExample', 6
FROM topic WHERE slug = 'spring-ioc-container';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, '@PostConstruct ve @PreDestroy', 'PostConstructPreDestroyExample', 7
FROM topic WHERE slug = 'spring-ioc-container';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'InitializingBean ve DisposableBean Arayüzleri', 'InitializingDisposableBeanExample', 8
FROM topic WHERE slug = 'spring-ioc-container';
