import { Controller } from "@hotwired/stimulus"
import { gsap } from "gsap"
import { ScrollTrigger } from "gsap/ScrollTrigger"

gsap.registerPlugin(ScrollTrigger)

// Connects to data-controller="gsap"
export default class extends Controller {
  connect() {
    //   document.addEventListener("turbo:load", () => {
    //   const title = document.querySelector("h1")
    //   if (title) {
    //     gsap.from(title, {
    //       duration: 1,
    //       y: -50,
    //       opacity: 0,
    //       ease: "power3.out"
    //     })
    //   }
    // })
    const sections = this.element.querySelectorAll("section, .banner")

    sections.forEach((section, index) => {
      const nextSection = sections[index + 1]
      if (!nextSection) return

      const tl = gsap.timeline({
        scrollTrigger: {
          trigger: section,
          start: "top top",
          end: "bottom top",
          scrub: true,
          markers: false, // set true to debug
        }
      })

      tl.fromTo(section,
        { opacity: 1, y: 0 },
        { opacity: 0, y: -50, ease: "power1.out" }
      )
      tl.fromTo(nextSection,
        { opacity: 0, y: 50 },
        { opacity: 1, y: 0, ease: "power1.out" },
        0 // start at same time as previous animation
      )
    })
  }
}
