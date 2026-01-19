document.addEventListener("DOMContentLoaded", function () {
    const button = document.querySelector(".theme-switch-button");
    if (button) {
        button.addEventListener("click", () => {
            const current = document.documentElement.dataset.theme;
            const next = current === "dark" ? "light" : "dark";
            document.documentElement.dataset.theme = next;
            localStorage.setItem("theme", next);
        });
    }
});