package com.cdurgun.learning.repository;

import com.cdurgun.learning.domain.IdentityProvider;
import com.cdurgun.learning.domain.User;
import com.cdurgun.learning.domain.UserIdentity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.Optional;

public interface UserIdentityRepository extends JpaRepository<UserIdentity, Long> {

    @Query("select i from UserIdentity i join fetch i.user " +
            "where i.provider = :provider and i.providerSubject = :subject")
    Optional<UserIdentity> findWithUser(@Param("provider") IdentityProvider provider,
                                        @Param("subject") String subject);

    boolean existsByProviderAndProviderSubject(IdentityProvider provider, String providerSubject);

    boolean existsByUserAndProvider(User user, IdentityProvider provider);
}
