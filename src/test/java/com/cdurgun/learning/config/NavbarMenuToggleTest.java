package com.cdurgun.learning.config;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.webmvc.test.autoconfigure.AutoConfigureMockMvc;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;

import static org.hamcrest.Matchers.allOf;
import static org.hamcrest.Matchers.containsString;
import static org.hamcrest.Matchers.not;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

/**
 * Navbar'daki hamburger butonu {@code #sidebarOffcanvas}'ı açar; sidebar'ı olmayan
 * sayfalarda (login/register, admin) render edilirse tıklanınca Bootstrap hata atar.
 * Bu yüzden buton yalnızca sidebar'lı sayfalarda bulunmalı (admin sayfası için bkz.
 * {@code QuestionReviewControllerTest}).
 */
@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
class NavbarMenuToggleTest {

    @Autowired
    private MockMvc mockMvc;

    @Test
    void authPagesHaveNoMenuToggle() throws Exception {
        for (String path : new String[] {"/en/login", "/tr/login", "/en/register", "/tr/register"}) {
            mockMvc.perform(get(path))
                    .andExpect(status().isOk())
                    .andExpect(content().string(allOf(
                            not(containsString("navbar-toggler")),
                            not(containsString("id=\"sidebarOffcanvas\"")))));
        }
    }

    @Test
    void sidebarPagesKeepMenuToggleAndSidebar() throws Exception {
        for (String path : new String[] {"/en", "/tr/topics/enum"}) {
            mockMvc.perform(get(path))
                    .andExpect(status().isOk())
                    .andExpect(content().string(allOf(
                            containsString("navbar-toggler"),
                            containsString("data-bs-target=\"#sidebarOffcanvas\""),
                            containsString("id=\"sidebarOffcanvas\""))));
        }
    }
}
