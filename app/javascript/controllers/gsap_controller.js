import { Controller } from "@hotwired/stimulus"
import { gsap } from "gsap"
import { ScrollTrigger } from "gsap/ScrollTrigger"

gsap.registerPlugin(ScrollTrigger)

// Connects to data-controller="gsap"
export default class extends Controller {
  connect() {
    this.loadSVGs();
  }

  // loadSVG() {
  //   fetch('/images/svg/timetouch.svg')
  //     .then(response => response.text())
  //     .then(data => {
  //       document.getElementById("svg_timetouch").innerHTML = data;
  //       document.querySelector("#svg_timetouch svg").setAttribute("preserveAspectRatio", "xMidYMid slice");
  //       this.setAnimationScroll();
  //     })
  // }

  async loadSVGs() {
  // Array de objetos com id e caminho do SVG
    const svgs = [
      { id: "svg_timetouch", url: "/images/svg/timetouch.svg" },
      { id: "svg_desafios", url: "/images/svg/desafios.svg" },

    ];

    try {
      // Cria um array de promises de fetch
      const fetchPromises = svgs.map(svg =>
        fetch(svg.url).then(response => response.text())
      );

      // Espera todas as promises serem resolvidas
      const results = await Promise.all(fetchPromises);

      // Insere os SVGs no DOM
      results.forEach((data, index) => {
        const svgContainer = document.getElementById(svgs[index].id);
        svgContainer.innerHTML = data;
        const svgElement = svgContainer.querySelector("svg");
        if (svgElement) {
          svgElement.setAttribute("preserveAspectRatio", "xMidYMid slice");
        }
      });

      // Chama a função de animação
      this.setAnimationScroll();

    } catch (error) {
      console.error("Erro ao carregar SVGs:", error);
    }
  }

  setAnimationScroll() {
    gsap.registerPlugin(ScrollTrigger);
    gsap.set("#svg_timetouch svg #Loading", { scaleX: 0, transformOrigin: "0 50%" });
    gsap.set("#svg_timetouch svg #popup", {opacity: 0, transformOrigin: "0 50%"});

    //Section_2
    gsap.set(["#section_2", "#section_2 #desafios", "#section_2 #desafio_1", "#section_2 #desafio_2", "#section_2 #desafio_3"],
      { opacity: 0 });

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
        endTrigger: "#section_2",
        end: "top+=20% top",
        scrub: 2.5,
        markers: false,
        pin: true,
        pinSpacing: true,
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
          duration: 3,
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
          duration: 3,
          ease: "power2.inOut"
        }, ">")
      .to("#svg_timetouch svg #popup", {
        scale: 5,
        ease: "power5.inOut",
        duration: 3,
        transformOrigin: "center center"
      })
      .to("#svg_timetouch svg #background", {
        ease: "power3.in",
        duration: 3,
        fill: "#E8F7EE"
      })
      .to(["#svg_timetouch svg #check", "#svg_timetouch svg #text"],
        { opacity: 0}, "<1>"
      )
      .to("#section_1", {
          opacity: 0,
          duration: 1,
          ease: "power2.in",
      }, "<1");



      //Section_2
      let section2Animation = gsap.timeline({
        scrollTrigger: {
          trigger: "#section_2",
          start: "top top",
          end: "bottom top",
          scrub: 2.5,
          pin: true,
          pinSpacing: true,
        }
      });

      section2Animation
        .to("#section_2", { opacity: 1, y: +200})
        .fromTo("#section_2 h2", {
          x: -200,
          opacity: 0,
          duration: 1.5,
          ease: "power2.out"
        }, {x: 0, opacity: 1})
        .fromTo("#section_2 #desafios", {
          opacity: 0
        }, {
          opacity: 1,
          delay: 2,
          ease: "power5.in",

        }, ">")
        .fromTo("#section_2 #desafio_1", {
          y: 50
        }, {
          y: 0,
          opacity: 1,
          ease: "power5.in",
          duration: 2,
          delay: 2.5
        })
        .fromTo("#section_2 #desafio_3", {
          y: 50
        }, {
          y: 0,
          opacity: 1,
          ease: "power5.in",
          duration: 2,
          delay: 3
        })
        .fromTo("#section_2 #desafio_2", {
          y: 50
        }, {
          y: 0,
          opacity: 1,
          ease: "power5.in",
          duration: 2,
          delay: 3.5
        })
  }
}
