/* =========================================================
   PURE & POWER — SHARED SITE ENGINE
   Static GitHub Pages demo with localStorage persistence.
   Production note: replace localStorage auth/payment with a backend.
   ========================================================= */

(() => {
    "use strict";

    const KEY = {
        users: "pp_users",
        currentUser: "pp_current_user",
        bookings: "pp_bookings",
        currentBooking: "pp_current_booking",
        profile: "pp_profile"
    };

    const $ = (selector, root = document) => root.querySelector(selector);
    const $$ = (selector, root = document) => [...root.querySelectorAll(selector)];

    const read = (key, fallback) => {
        try {
            const value = localStorage.getItem(key);
            return value ? JSON.parse(value) : fallback;
        } catch (error) {
            console.error("Storage read error:", error);
            return fallback;
        }
    };

    const write = (key, value) => {
        localStorage.setItem(key, JSON.stringify(value));
    };

    const remove = (key) => localStorage.removeItem(key);

    const escapeHtml = (value = "") => String(value)
        .replaceAll("&", "&amp;")
        .replaceAll("<", "&lt;")
        .replaceAll(">", "&gt;")
        .replaceAll('"', "&quot;")
        .replaceAll("'", "&#039;");

    const todayISO = () => new Date().toISOString().slice(0, 10);

    const formatDate = (value) => {
        if (!value) return "—";
        const date = new Date(`${value}T00:00:00`);
        if (Number.isNaN(date.getTime())) return value;
        return date.toLocaleDateString("fr-FR", {
            weekday: "short",
            day: "2-digit",
            month: "short",
            year: "numeric"
        });
    };

    const currentPath = window.location.pathname.split("/").pop() || "index.html";

    const getCurrentUser = () => read(KEY.currentUser, null);

    const getUsers = () => read(KEY.users, []);

    const saveUsers = (users) => write(KEY.users, users);

    const getBookings = () => read(KEY.bookings, []);

    const saveBookings = (bookings) => write(KEY.bookings, bookings);

    const showToast = (message, type = "success") => {
        let toast = $("#ppToast");
        if (!toast) {
            toast = document.createElement("div");
            toast.id = "ppToast";
            toast.style.cssText = `
                position:fixed;right:20px;bottom:20px;z-index:9999;
                max-width:360px;padding:14px 18px;border-radius:14px;
                color:#fff;font:700 14px/1.4 "DM Sans",sans-serif;
                box-shadow:0 18px 35px rgba(23,50,77,.22);
                transition:opacity .25s ease,transform .25s ease;
            `;
            document.body.appendChild(toast);
        }
        toast.style.background = type === "error" ? "#b84f4f" : "#2E6B47";
        toast.textContent = message;
        toast.style.opacity = "1";
        toast.style.transform = "translateY(0)";
        clearTimeout(toast._timer);
        toast._timer = setTimeout(() => {
            toast.style.opacity = "0";
            toast.style.transform = "translateY(10px)";
        }, 3200);
    };

    /* ---------------- Password hashing ---------------- */
    async function hashPassword(password) {
        if (window.crypto?.subtle) {
            const data = new TextEncoder().encode(password);
            const digest = await crypto.subtle.digest("SHA-256", data);
            return [...new Uint8Array(digest)]
                .map(byte => byte.toString(16).padStart(2, "0"))
                .join("");
        }
        return btoa(unescape(encodeURIComponent(password)));
    }

    /* ---------------- Global navigation ---------------- */
    function setupNavigation() {
        const indexMap = {
            "#services": "services.html",
            "#tarifs": "tarifs.html",
            "#experience": "experience.html",
            "#contact": "contact.html",
            "#accueil": "index.html"
        };

        $$("a[href^='#']").forEach(link => {
            const href = link.getAttribute("href");
            if (indexMap[href] && currentPath !== "index.html") {
                link.setAttribute("href", indexMap[href]);
            } else if (indexMap[href] && currentPath === "index.html" && href !== "#accueil") {
                link.setAttribute("href", indexMap[href]);
            }
        });

        const activeName = currentPath.replace(".html", "");
        $$("a[href]").forEach(link => {
            const href = link.getAttribute("href") || "";
            if (!href.includes("#") && href.endsWith(`${activeName}.html`)) {
                link.classList.add("active");
            }
        });

        const user = getCurrentUser();
        const clientLinks = $$("a[href='login.html'], a[href='dashboard.html']");
        clientLinks.forEach(link => {
            if (user && link.getAttribute("href") === "login.html") {
                link.setAttribute("href", "dashboard.html");
                link.textContent = "Mon espace";
            }
        });
    }

    /* ---------------- Page transitions ---------------- */
    function setupTransitions() {
        document.body.classList.add("pp-ready");
        $$("a[href$='.html']").forEach(link => {
            if (link.target === "_blank" || link.hasAttribute("download")) return;
            link.addEventListener("click", event => {
                const href = link.getAttribute("href");
                if (!href || href.startsWith("http") || href.startsWith("#")) return;
                if (href === window.location.pathname.split("/").pop()) return;
                event.preventDefault();
                document.body.classList.add("pp-leaving");
                setTimeout(() => { window.location.href = href; }, 120);
            });
        });
    }

    /* ---------------- Registration ---------------- */
    async function setupRegister() {
        if (!currentPath.includes("register")) return;
        const form = $("form");
        if (!form) return;

        form.onsubmit = async event => {
            event.preventDefault();
            const inputs = $$("input", form);
            const firstName = inputs[0]?.value.trim() || "";
            const lastName = inputs[1]?.value.trim() || "";
            const email = (inputs[2]?.value || "").trim().toLowerCase();
            const phone = inputs[3]?.value.trim() || "";
            const password = inputs[4]?.value || "";

            if (!firstName || !lastName || !email || !phone || password.length < 6) {
                showToast("Veuillez compléter correctement le formulaire. Le mot de passe doit contenir au moins 6 caractères.", "error");
                return;
            }

            const users = getUsers();
            if (users.some(user => user.email === email)) {
                showToast("Un compte existe déjà avec cette adresse email.", "error");
                return;
            }

            const user = {
                id: `USR-${Date.now()}`,
                firstName,
                lastName,
                email,
                phone,
                passwordHash: await hashPassword(password),
                role: "client",
                createdAt: new Date().toISOString()
            };

            users.push(user);
            saveUsers(users);
            write(KEY.currentUser, { ...user, passwordHash: undefined });
            write(KEY.profile, {
                firstName,
                lastName,
                email,
                phone,
                address: "",
                city: "Ajaccio"
            });

            showToast("Compte créé avec succès. Redirection vers votre espace…");
            setTimeout(() => { window.location.href = "dashboard.html"; }, 700);
        };
    }

    /* ---------------- Login ---------------- */
    async function setupLogin() {
        if (!currentPath.includes("login")) return;
        const form = $("form");
        if (!form) return;

        form.onsubmit = async event => {
            event.preventDefault();
            const emailInput = $("input[type='email']", form);
            const passwordInput = $("input[type='password']", form);
            const email = (emailInput?.value || "").trim().toLowerCase();
            const password = passwordInput?.value || "";

            const users = getUsers();
            const hash = await hashPassword(password);
            const user = users.find(item => item.email === email && item.passwordHash === hash);

            if (!user) {
                showToast("Email ou mot de passe incorrect.", "error");
                return;
            }

            write(KEY.currentUser, {
                id: user.id,
                firstName: user.firstName,
                lastName: user.lastName,
                email: user.email,
                phone: user.phone,
                role: user.role
            });

            showToast("Connexion réussie. Bienvenue !");
            setTimeout(() => { window.location.href = "dashboard.html"; }, 500);
        };
    }

    /* ---------------- Auth guard ---------------- */
    function guardClientPages() {
        const protectedPages = [
            "dashboard.html",
            "reservations.html",
            "contract.html",
            "payment.html",
            "profile.html"
        ];

        if (!protectedPages.includes(currentPath)) return;
        if (!getCurrentUser()) {
            window.location.replace("login.html?redirect=" + encodeURIComponent(currentPath));
        }
    }

    /* ---------------- Dashboard ---------------- */
    function setupDashboard() {
        if (currentPath !== "dashboard.html") return;
        const user = getCurrentUser();
        const bookings = getBookings().filter(item => item.userId === user?.id);
        const latest = bookings[bookings.length - 1];

        $$(".hero-mini h1").forEach(el => {
            if (el.textContent.includes("Votre")) {
                el.innerHTML = `Bonjour <span>${escapeHtml(user?.firstName || "Client")}</span>`;
            }
        });

        const stats = $$(".stat strong");
        if (stats[0]) stats[0].textContent = String(bookings.length).padStart(2, "0");
        if (stats[1]) stats[1].textContent = latest ? formatDate(latest.date) : "—";
        if (stats[2]) stats[2].textContent = latest ? "En préparation" : "—";
        if (stats[3]) stats[3].textContent = latest?.paymentStatus || "—";
    }

    /* ---------------- Booking ---------------- */
    function setupBooking() {
        if (currentPath !== "booking.html") return;
        const form = $("#bookingForm");
        if (!form) return;
        const dateInput = $("#bookingDate");
        if (dateInput && !dateInput.min) dateInput.min = todayISO();

        form.onsubmit = event => {
            event.preventDefault();
            const user = getCurrentUser();
            if (!user) {
                const pending = {
                    firstName: $("#firstName")?.value.trim() || "",
                    lastName: $("#lastName")?.value.trim() || "",
                    phone: $("#phone")?.value.trim() || "",
                    email: $("#email")?.value.trim().toLowerCase() || "",
                    service: $("#service")?.value || "",
                    date: $("#bookingDate")?.value || "",
                    time: $("#bookingTime")?.value || "",
                    address: $("#address")?.value.trim() || "",
                    city: $("#city")?.value.trim() || "Ajaccio",
                    needs: $("#needs")?.value.trim() || ""
                };
                write(KEY.currentBooking, pending);
                showToast("Connectez-vous pour confirmer la réservation.", "error");
                setTimeout(() => { window.location.href = "login.html?redirect=booking.html"; }, 600);
                return;
            }

            const service = $("#service")?.value || "";
            const date = $("#bookingDate")?.value || "";
            const time = $("#bookingTime")?.value || "";
            const address = $("#address")?.value.trim() || "";
            const city = $("#city")?.value.trim() || "Ajaccio";
            const needs = $("#needs")?.value.trim() || "";

            if (!service || !date || !time || !address) {
                showToast("Sélectionnez une prestation, une date, un horaire et une adresse.", "error");
                return;
            }

            const booking = {
                id: `BK-${Date.now()}`,
                userId: user.id,
                name: `${user.firstName} ${user.lastName}`,
                email: user.email,
                service,
                date,
                time,
                address,
                city,
                needs,
                status: "En attente",
                contractStatus: "En préparation",
                paymentStatus: "En attente",
                createdAt: new Date().toISOString()
            };

            const bookings = getBookings();
            bookings.push(booking);
            saveBookings(bookings);
            remove(KEY.currentBooking);
            showToast("Votre demande a bien été enregistrée !");
            setTimeout(() => { window.location.href = "reservations.html"; }, 700);
        };
    }

    /* ---------------- Reservations ---------------- */
    function setupReservations() {
        if (currentPath !== "reservations.html") return;
        const user = getCurrentUser();
        const bookings = getBookings().filter(item => item.userId === user?.id);
        const tableBody = $(".table tbody");
        if (!tableBody) return;

        if (!bookings.length) {
            tableBody.innerHTML = `<tr><td colspan="5" style="text-align:center;padding:30px;color:#687780">Aucune réservation pour le moment.</td></tr>`;
            return;
        }

        tableBody.innerHTML = bookings.map(item => `
            <tr>
                <td>${escapeHtml(item.service)}</td>
                <td>${escapeHtml(formatDate(item.date))}</td>
                <td>${escapeHtml(item.time)}</td>
                <td>${escapeHtml(item.city || item.address)}</td>
                <td><span class="status">${escapeHtml(item.status)}</span></td>
            </tr>
        `).join("");
    }

    /* ---------------- Contract ---------------- */
    function setupContract() {
        if (currentPath !== "contract.html") return;
        const user = getCurrentUser();
        const latest = getBookings().filter(item => item.userId === user?.id).at(-1);
        if (!latest) return;
        const card = $(".card");
        if (!card) return;
        const paragraphs = $$(`p`, card);
        if (paragraphs[0]) paragraphs[0].innerHTML = `<strong>Client :</strong> ${escapeHtml(user.firstName)} ${escapeHtml(user.lastName)}`;
        if (paragraphs[1]) paragraphs[1].innerHTML = `<strong>Service :</strong> ${escapeHtml(latest.service)}`;
        if (paragraphs[2]) paragraphs[2].innerHTML = `<strong>Statut :</strong> <span class="status">${escapeHtml(latest.contractStatus)}</span>`;
    }

    /* ---------------- Payment demo ---------------- */
    function setupPayment() {
        if (currentPath !== "payment.html") return;
        const user = getCurrentUser();
        const bookings = getBookings().filter(item => item.userId === user?.id);
        const latest = bookings.at(-1);
        if (!latest) return;
        const priceMap = {
            "Ménage courant — 20 €/h": "20 € / h",
            "Ménage approfondi — 25 €/h": "25 € / h",
            "Nettoyage des vitres — dès 5 €/vitre": "À partir de 5 € / vitre",
            "Forfait Studio — dès 35 €": "À partir de 35 €",
            "Forfait T2 — dès 45 €": "À partir de 45 €",
            "Forfait T3 — dès 60 €": "À partir de 60 €",
            "Repassage — sur devis": "Sur devis"
        };
        const priceEl = $(".price");
        const statusEl = $(".status");
        if (priceEl) priceEl.textContent = priceMap[latest.service] || "À confirmer";
        if (statusEl) statusEl.textContent = latest.paymentStatus;

        const wrap = $(".form-wrap");
        if (wrap && latest.paymentStatus === "En attente") {
            const button = document.createElement("button");
            button.className = "btn btn-green";
            button.type = "button";
            button.textContent = "Simuler le paiement →";
            button.style.marginTop = "20px";
            button.addEventListener("click", () => {
                const bookings = getBookings();
                const index = bookings.findIndex(item => item.id === latest.id);
                if (index >= 0) {
                    bookings[index].paymentStatus = "Payé";
                    saveBookings(bookings);
                    showToast("Paiement simulé avec succès.");
                    setTimeout(() => window.location.reload(), 500);
                }
            });
            wrap.appendChild(button);
        }
    }

    /* ---------------- Profile ---------------- */
    function setupProfile() {
        if (currentPath !== "profile.html") return;
        const user = getCurrentUser();
        const form = $("form");
        if (!form || !user) return;
        const inputs = $$("input", form);
        const profile = read(KEY.profile, user);
        if (inputs[0]) inputs[0].value = profile.firstName || user.firstName || "";
        if (inputs[1]) inputs[1].value = profile.lastName || user.lastName || "";
        if (inputs[2]) inputs[2].value = profile.email || user.email || "";
        if (inputs[3]) inputs[3].value = profile.phone || user.phone || "";
        if (inputs[4]) inputs[4].value = profile.address || "";

        form.onsubmit = event => {
            event.preventDefault();
            write(KEY.profile, {
                firstName: inputs[0]?.value.trim() || "",
                lastName: inputs[1]?.value.trim() || "",
                email: inputs[2]?.value.trim().toLowerCase() || "",
                phone: inputs[3]?.value.trim() || "",
                address: inputs[4]?.value.trim() || "",
                city: profile.city || "Ajaccio"
            });
            showToast("Informations enregistrées.");
        };
    }

    /* ---------------- Logout ---------------- */
    function injectLogout() {
        const user = getCurrentUser();
        if (!user) return;
        if (["dashboard.html","reservations.html","contract.html","payment.html","profile.html"].includes(currentPath)) {
            const nav = $(".page-links");
            if (nav && !$("#ppLogout", nav)) {
                const link = document.createElement("a");
                link.id = "ppLogout";
                link.href = "#";
                link.textContent = "Déconnexion";
                link.style.color = "#b84f4f";
                link.addEventListener("click", event => {
                    event.preventDefault();
                    remove(KEY.currentUser);
                    showToast("Vous êtes déconnecté.");
                    setTimeout(() => window.location.href = "index.html", 350);
                });
                nav.appendChild(link);
            }
        }
    }

    /* ---------------- Boot ---------------- */
    function boot() {
        setupNavigation();
        guardClientPages();
        setupTransitions();
        setupRegister();
        setupLogin();
        setupBooking();
        setupDashboard();
        setupReservations();
        setupContract();
        setupPayment();
        setupProfile();
        injectLogout();
    }

    if (document.readyState === "loading") {
        document.addEventListener("DOMContentLoaded", boot, { once: true });
    } else {
        boot();
    }
})();