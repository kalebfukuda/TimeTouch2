import { Controller } from "@hotwired/stimulus"
import anime from "animejs"

// Connects to data-controller="anime"
export default class extends Controller {
  connect() {
    document.addEventListener("turbo:load", () => {
    const header = document.querySelector("h1:last-of-type")
    if (header) {
      anime({
        targets: header,
        translateY: [-50, 0],
        opacity: [0, 1],
        duration: 1000,
        easing: "easeOutElastic(1.5, .8)"
      })
    }
  })
  }
}
