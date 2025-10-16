import { Controller } from "@hotwired/stimulus"
import { gsap } from "gsap"

// Connects to data-controller="gsap"
export default class extends Controller {
  connect() {
      document.addEventListener("turbo:load", () => {
      const title = document.querySelector("h1")
      if (title) {
        gsap.from(title, {
          duration: 1,
          y: -50,
          opacity: 0,
          ease: "power3.out"
        })
      }
    })

  }
}
