/* =========================================================
   PURE & POWER
   Main JavaScript
   ========================================================= */


/* =========================================================
   01. DOM ELEMENTS
   ========================================================= */

const menuToggle = document.getElementById("menuToggle");
const mainNav = document.getElementById("mainNav");
const header = document.getElementById("header");


/* =========================================================
   02. MOBILE MENU
   ========================================================= */

if (menuToggle && mainNav) {

    menuToggle.addEventListener("click", () => {

        const isOpen = mainNav.classList.toggle("active");

        menuToggle.setAttribute(
            "aria-expanded",
            isOpen ? "true" : "false"
        );

        menuToggle.innerHTML = isOpen ? "✕" : "☰";

    });


    // Close menu when clicking a navigation link

    const navLinks = mainNav.querySelectorAll("a");

    navLinks.forEach((link) => {

        link.addEventListener("click", () => {

            mainNav.classList.remove("active");

            menuToggle.setAttribute(
                "aria-expanded",
                "false"
            );

            menuToggle.innerHTML = "☰";

        });

    });


    // Close menu when clicking outside

    document.addEventListener("click", (event) => {

        const clickedInsideNav =
            mainNav.contains(event.target);

        const clickedMenuButton =
            menuToggle.contains(event.target);

        if (
            !clickedInsideNav &&
            !clickedMenuButton &&
            mainNav.classList.contains("active")
        ) {

            mainNav.classList.remove("active");

            menuToggle.setAttribute(
                "aria-expanded",
                "false"
            );

            menuToggle.innerHTML = "☰";

        }

    });

}


/* =========================================================
   03. HEADER SCROLL EFFECT
   ========================================================= */

function updateHeader() {

    if (!header) {
        return;
    }

    if (window.scrollY > 30) {

        header.classList.add("scrolled");

    } else {

        header.classList.remove("scrolled");

    }

}


window.addEventListener(
    "scroll",
    updateHeader,
    { passive: true }
);

updateHeader();


/* =========================================================
   04. SMOOTH SCROLL
   ========================================================= */

const internalLinks =
    document.querySelectorAll(
        'a[href^="#"]'
    );


internalLinks.forEach((link) => {

    link.addEventListener("click", (event) => {

        const targetId =
            link.getAttribute("href");

        if (
            !targetId ||
            targetId === "#"
        ) {
            return;
        }


        const target =
            document.querySelector(targetId);

        if (!target) {
            return;
        }


        event.preventDefault();


        const headerHeight =
            header
                ? header.offsetHeight
                : 0;


        const targetPosition =
            target.getBoundingClientRect().top +
            window.scrollY -
            headerHeight;


        window.scrollTo({
            top: targetPosition,
            behavior: "smooth"
        });

    });

});


/* =========================================================
   05. INTERSECTION OBSERVER
   ========================================================= */

const animatedElements = document.querySelectorAll(
    `
    .service-card,
    .price-card,
    .experience-box,
    .contact-card,
    .package,
    .hero-content,
    .hero-visual
    `
);


if ("IntersectionObserver" in window) {

    const observerOptions = {
        threshold: 0.12,
        rootMargin: "0px 0px -40px 0px"
    };


    const observer =
        new IntersectionObserver(
            (entries, observerInstance) => {

                entries.forEach((entry) => {

                    if (!entry.isIntersecting) {
                        return;
                    }


                    entry.target.classList.add(
                        "is-visible"
                    );


                    observerInstance.unobserve(
                        entry.target
                    );

                });

            },
            observerOptions
        );


    animatedElements.forEach((element) => {

        element.classList.add(
            "animate-on-scroll"
        );

        observer.observe(element);

    });

}


/* =========================================================
   06. ACTIVE NAVIGATION
   ========================================================= */

const sections = document.querySelectorAll(
    "main section[id]"
);

const navigationLinks =
    document.querySelectorAll(
        '.main-nav a[href^="#"]'
    );


if (
    sections.length &&
    navigationLinks.length &&
    "IntersectionObserver" in window
) {

    const sectionObserver =
        new IntersectionObserver(
            (entries) => {

                entries.forEach((entry) => {

                    if (!entry.isIntersecting) {
                        return;
                    }


                    const currentId =
                        entry.target.getAttribute("id");


                    navigationLinks.forEach((link) => {

                        const linkTarget =
                            link.getAttribute("href");


                        link.classList.toggle(
                            "active",
                            linkTarget === `#${currentId}`
                        );

                    });

                });

            },
            {
                threshold: 0.15,
                rootMargin:
                    "-20% 0px -60% 0px"
            }
        );


    sections.forEach((section) => {

        sectionObserver.observe(section);

    });

}


/* =========================================================
   07. TELEPHONE LINK PROTECTION
   ========================================================= */

const phoneLinks =
    document.querySelectorAll(
        'a[href^="tel:"]'
    );


phoneLinks.forEach((link) => {

    link.addEventListener("click", () => {

        const number =
            link.getAttribute("href");

        if (!number) {
            return;
        }

        console.log(
            `Appel demandé : ${number.replace(
                "tel:",
                ""
            )}`
        );

    });

});


/* =========================================================
   08. HERO IMAGE FALLBACK
   ========================================================= */

const heroImage =
    document.querySelector(
        ".hero-image img"
    );

const imagePlaceholder =
    document.querySelector(
        ".image-placeholder"
    );


if (heroImage && imagePlaceholder) {

    function checkHeroImage() {

        if (
            heroImage.complete &&
            heroImage.naturalWidth > 0
        ) {

            imagePlaceholder.style.display =
                "none";

        } else {

            imagePlaceholder.style.display =
                "flex";

        }

    }


    heroImage.addEventListener(
        "load",
        checkHeroImage
    );


    heroImage.addEventListener(
        "error",
        () => {

            heroImage.style.display =
                "none";

            imagePlaceholder.style.display =
                "flex";

        }
    );


    checkHeroImage();

}


/* =========================================================
   09. CURRENT YEAR
   ========================================================= */

const yearElements =
    document.querySelectorAll(
        "[data-current-year]"
    );


yearElements.forEach((element) => {

    element.textContent =
        new Date().getFullYear();

});


/* =========================================================
   10. ESCAPE KEY
   ========================================================= */

document.addEventListener(
    "keydown",
    (event) => {

        if (
            event.key === "Escape" &&
            mainNav &&
            mainNav.classList.contains("active")
        ) {

            mainNav.classList.remove(
                "active"
            );


            if (menuToggle) {

                menuToggle.setAttribute(
                    "aria-expanded",
                    "false"
                );

                menuToggle.innerHTML = "☰";

            }

        }

    }
);


/* =========================================================
   11. PAGE LOADED
   ========================================================= */

document.addEventListener(
    "DOMContentLoaded",
    () => {

        document.body.classList.add(
            "page-loaded"
        );

        console.log(
            "PURE & POWER — Site initialisé."
        );

    }
);