import { Controller } from "@hotwired/stimulus"
import { gsap } from "gsap"
import { ScrollTrigger } from "gsap/ScrollTrigger"

gsap.registerPlugin(ScrollTrigger)

// Connects to data-controller="gsap"
export default class extends Controller {
  connect() {
    this.loadSVG();
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
    gsap.set("#svg_timetouch svg #popup", {opacity: 0, transformOrigin: "0 50%"});

    //Circle check
    const checkBorder = document.getElementById("border");
    const length = checkBorder.getTotalLength();

    checkBorder.style.strokeDasharray = length;
    checkBorder.style.strokeDashoffset = length;

    // Animate text
    gsap.from("#span_1", {
      opacity: 1,
      x: -300,
      duration: 1.3,
      ease: "power3.out"
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


    runAnimation
      .fromTo("#svg_timetouch svg",
        { scale: 1 },
        { opacity: 1, y: -350, scale: 1.2, duration: 5 }
      )
       .to("#span_1", {
          opacity: 0,
          y: -20,
          duration: 3,
          ease: "power2.out"
        },
        "<1")
      .fromTo("#svg_timetouch svg #clicker",
        { opacity: 0 },
        { opacity:1, ease: "power5.in", duration: 3},
        ">")
      .to("#svg_timetouch svg #Loading", {
          scaleX: 1,
          duration: 5,
          ease: "power5.out",
        }, ">")
      .fromTo(["#svg_timetouch svg #popup", "#svg_timetouch svg #background"], {
          opacity: 0
        } ,
        {
          opacity: 1,
          ease: "power2.out",
          duration: 3,
        }, ">")
      .to(checkBorder, {
          strokeDashoffset: 0,
          stroke: "#B4DFDD",
          duration: 5,
          ease: "power2.inOut"
        }, ">")
      .to("#svg_timetouch svg #popup", {
        scale: 5,
        ease: "power5.inOut",
        duration: 6,
        transformOrigin: "center center"
      })
      .to(["#svg_timetouch svg #check", "#svg_timetouch svg #text"],
        { opacity: 0}, ">"
      );
  }
}
