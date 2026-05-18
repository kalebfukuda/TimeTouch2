import { Controller } from "@hotwired/stimulus"
import { gsap } from "gsap"
import { ScrollTrigger } from "gsap/ScrollTrigger"
import { ScrollToPlugin } from "gsap/ScrollToPlugin"

gsap.registerPlugin(ScrollTrigger, ScrollToPlugin)

// Connects to data-controller="gsap"
export default class extends Controller {
  connect() {
    this.loadSVGs();
  }

  async loadSVGs() {
  // Array de objetos com id e caminho do SVG
    const svgs = [
      { id: "svg_timetouch", url: "/images/svg/timetouch.svg" }
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
    const tlHero = gsap.timeline();
    const tlProblems = gsap.timeline({
      scrollTrigger: {
        trigger: "#problems",
        start: "top 40%"
      }
    });
    const tlSolution = gsap.timeline({
      scrollTrigger: {
        trigger: "#solution",
        start: "top 40%"
      }
    });

    const counterExtraHours = {
      value: 0
    };
    const counterTotalEarned = {
      value: 0
    };
    const counterActiveEmployees = {
      value: 0
    };

    //Section_hero
    tlHero.from("#headline",{
      opacity: 0,
      y: 80,
      duration: 0.6
      }, "start"
    ).from("#subheadline", {
      opacity: 0,
      y: 80,
      duration: 0.6
    }, "start+=0.2"
    ).from("#divCta", {
      opacity: 0, y: 80
    }, "start+=0.4")
    .from(".browser-wrapper", {
      opacity: 0,
      y: 40,
      scale: 1.1,
      duration: 1,
      ease: "power3.out"
    }, "start+=0.6")
   .from("#top-menu", {
      opacity: 0, x: 80
    }, "start+=0.8")
     .from("#home-company", {
      opacity: 0, x: -80
    }, "start+=1.0")
    .from("#cardTable", {
      opacity: 0, y: 80
    }, "start+=1.2")
    .from(".table-row", {
      opacity: 0,
      x: 100,
      duration: 0.4,
      stagger: 0.08,
      ease: "power2.out"
    }, "start+=1.2")
    .from("#cardExtraHours", {
      opacity: 0, y: 80
    }, "start+=1.2")
    .to(counterExtraHours, {
      value: 34,
      duration: 1,
      ease: "power2.out",
      onUpdate: () => {
        document.querySelector("#extra-hours-value").textContent =
          Math.floor(counterExtraHours.value) + "h";
      }
    }, "start+=1.0")
    .from("#cardTotalEarned", {
      opacity: 0, y: 80
    }, "start+=1.4")
    .to(counterTotalEarned, {
      value: 1669967,
      duration: 0.8,
      ease: "power2.out",
      onUpdate: () => {
        document.querySelector("#total-earned-value").textContent =
          "¥" + Math.round(counterTotalEarned.value).toLocaleString("de-DE");
      }
    }, "start+=1.2")
    .from("#cardActiveEmployees", {
      opacity: 0, y: 80
    }, "start+=1.6")
    .to(counterActiveEmployees, {
      value: 5,
      duration: 1,
      ease: "power2.out",
      onUpdate: () => {
        document.querySelector("#active-employees-value").textContent =
          Math.floor(counterActiveEmployees.value);
      }
    }, "start+=1.8")
    .from("#table-registers", {
      opacity: 0, y: 100
    }, "start+=1.8")
    .from(".table-row-register", {
      opacity: 0,
      x: 100,
      duration: 0.4,
      stagger: 0.08,
      ease: "power2.out"
    }, "start+=1.8");

    //tl problems
    tlProblems
  .from("#problems-title", {
    opacity: 0,
    y: 60,
    duration: 0.8,
    ease: "power3.out"
  }, "start")
  .from(".problems-title", {
    opacity: 0,
    y:100,
    duration: 0.4,
    stagger: 0.1,
    ease: "power2.out"
  }, "start+=0.4")
  .fromTo(".problem-card",
    {
      opacity: 0,
      y: 60,
      scale: 0.88,
    },
    {
      opacity: 1,
      y: 0,
      scale: 1,
      duration: 0.7,
      stagger: {
        amount: 0.6,        // tempo total distribuído entre os cards
        from: "start",
        onStart: function() {
          // alterna rotação por índice: par vai de -3, ímpar de +3
          const el = this.targets()[0];
          const idx = [...document.querySelectorAll(".problem-card")].indexOf(el);
          gsap.from(el, {
            rotation: idx % 2 === 0 ? -3 : 3,
            duration: 0.7,
            ease: "back.out(1.7)"
          });
        }
      },
      ease: "back.out(1.7)"
    },
  "start+=0.3");


    //Section_3
    gsap.set(["#section_3"],
      { opacity: 0}
    );


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
        scrub: 2.5,
        markers: false,
        pin: true,
        pinSpacing: true,
        onLeave: () => {
          gsap.to(window, {
            duration: 1.0,
            scrollTo: "#section_2",
            ease: "power2.inOut"
          })
        }
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
          start: "top-=10% top",
          end: "+=1000",
          scrub: true,
          markers: true,
          pin: true,
          pinSpacing: true,
          onLeave: () => {
            gsap.to(window, {
              duration: 1.5,
              scrollTo: "#section_3",
              ease: "power2.inOut"
            })
          }
        }
      });

      section2Animation
        .fromTo("#section_2 #desafio_1", {
          x: -200
        }, {
          x: -50,
          opacity: 1,
          duration: 3,
          ease: "power5.in",
        }, "<1")
        .fromTo("#section_2 #desafio_2", {
          x: -200,
        }, {
          x: 50,
          opacity: 1,
          duration: 3,
          ease: "power5.in",
        }, ">")
        .fromTo("#section_2 #desafio_3", {
          x: -200
        }, {
          x: -50,
          opacity: 1,
          duration: 3,
          ease: "power5.in",
        }, ">")
        .fromTo("#section_2 #desafio_result",
          { opacity: 0 },
          { opacity: 1, duration: 4, ease: "power5.out" },
          "+=0.5")
  }
}
