document.addEventListener("turbo:load", () => {
  document.querySelectorAll(".gemba-icon").forEach((icon) => {
    icon.addEventListener("click", () => {
      const checkbox = icon.parentElement.querySelector(".gemba-checkbox");

      checkbox.checked = !checkbox.checked;

      if (checkbox.checked) {
        icon.classList.remove("fa-x", "text-cRed");
        icon.classList.add("fa-check", "text-cGreen");
      } else {
        icon.classList.remove("fa-check", "text-cGreen");
        icon.classList.add("fa-x", "text-cRed");
      }
    });
  });
});
