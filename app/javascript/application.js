// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "@popperjs/core"
import "bootstrap"
import anime from "animejs"

document.addEventListener("turbo:load", () => {
  const header = document.querySelector("h1:last-of-type")
  if (header) {
    anime({
      targets: header,
      translateY: [-50, 0],
      opacity: [0, 1],
      duration: 1000,
      easing: "easeOutElastic(1, .8)"
    })
  }
})
