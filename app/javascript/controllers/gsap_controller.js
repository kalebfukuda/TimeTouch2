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
    this.loadSVG();
    // const sections = this.element.querySelectorAll("section, .banner")

    // sections.forEach((section, index) => {
    //   const nextSection = sections[index + 1]
    //   if (!nextSection) return

    //   const tl = gsap.timeline({
    //     scrollTrigger: {
    //       trigger: section,
    //       start: "top top",
    //       end: "bottom top",
    //       scrub: true,
    //       markers: false, // set true to debug
    //     }
    //   })

    //   tl.fromTo(section,
    //     { opacity: 1, y: 0 },
    //     { opacity: 0, y: -50, ease: "power1.out" }
    //   )
    //   tl.fromTo(nextSection,
    //     { opacity: 0, y: 50 },
    //     { opacity: 1, y: 0, ease: "power1.out" },
    //     0 // start at same time as previous animation
    //   )
    // })
  }

  loadSVG() {
    fetch('/images/svg/timetouch.svg')
      .then(response => response.text())
      .then(data => {
        document.getElementById("svg_timetouch").innerHTML = data;
        document.querySelector("#svg_timetouch svg").setAttribute("preserveAspectRatio", "xMidYMid slice");
        this.setAnimationScroll();
      })
  }

  setAnimationScroll() {
    gsap.registerPlugin(ScrollTrigger);
    gsap.set("#svg_timetouch svg #Loading", { scaleX: 0, transformOrigin: "0 50%" });

    // Animate text
    gsap.from("#span_1", {
      opacity: 1,         // começa invisível
      x: -300,              // desloca 20px para baixo
      duration: 1.3,
      ease: "power3.out"  // suaviza a animação
    });

    // Animate SVG timetouch
    gsap.from("#svg_timetouch svg", {
      opacity: 1,
      scale: 0.8,
      transformOrigin: "center center",
      duration: 1.3,
      ease: "power2.out",
    });

    let runAnimation = gsap.timeline({
      scrollTrigger: {
        trigger: "#section_1",
        start: "top top",
        end: "bottom top",
        scrub: true,
        markers: false,
        pin: true
      }
    });


    runAnimation.add([
      gsap.fromTo("#svg_timetouch svg",
        { scale: 1 },
        { opacity: 1, y: -350, scale: 1.2, duration: 5 }
      ),
       gsap.to("#span_1", {
        opacity: 0,
        y: -20,
        duration: 3,
        ease: "power2.out"
      }),
      gsap.to("#svg_timetouch svg #Loading", {
        scaleX: 1,
        duration: 5,
        delay: 3.5,
        ease: "power5.out"
      })
    ]);





    // gsap.to("#bg_lamp svg #path29", {
    //     x: 200, // Move 200 pixels to the right
    //     rotation: 360, // Rotate 360 degrees
    //     delay: 0.5,
    //     duration: 1, // Animation duration (this will be controlled by scroll)
    //   })

    // runAnimation.to("#bg_lamp", {
    //     scale: 1.3,
    //     opacity: 0,
    //     transformOrigin: "center center",
    //     ease: "power2.inOut",
    //   })


    // runAnimation.fromTo(
    //     "#banner_section",
    //     { scale: 0.8, opacity: 0 },
    //     { scale: 1, opacity: 1, ease: "power2.inOut" },
    //     0 // simultâneo
    //   )

  }
}
