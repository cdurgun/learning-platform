package com.cdurgun.learning.repository;

import com.cdurgun.learning.domain.Course;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface CourseRepository extends JpaRepository<Course, Long> {

    Optional<Course> findBySlug(String slug);

    List<Course> findAllByOrderBySortOrderAsc();
}
