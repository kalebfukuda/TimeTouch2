# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "bootstrap", to: "bootstrap.min.js", preload: true
pin "@popperjs/core", to: "popper.js", preload: true
pin "animejs", to: "https://cdn.jsdelivr.net/npm/animejs@3.2.1/lib/anime.es.js"
pin "gsap", to: "https://esm.sh/gsap@3.13.0"
pin "gsap/ScrollTrigger", to: "https://ga.jspm.io/npm:gsap@3.12.2/ScrollTrigger.js"
pin "gsap/ScrollToPlugin", to: "https://ga.jspm.io/npm:gsap@3.12.2/ScrollToPlugin.js"
