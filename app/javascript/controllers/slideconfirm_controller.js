import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="slideconfirm"
export default class extends Controller {
  static targets = ["track", "handle", "hidden"]

  connect() {
    this.dragging = false;
    this.startX = 0;
    // Calculate maxX once on connect
    this.maxX = this.trackTarget.offsetWidth - this.handleTarget.offsetWidth;

    // --- Desktop Mouse Events ---
    this.handleTarget.addEventListener("mousedown", this.startDrag.bind(this));
    document.addEventListener("mousemove", this.onDrag.bind(this));
    document.addEventListener("mouseup", this.stopDrag.bind(this));

    // --- Mobile Touch Events ---
    // Use { passive: false } for startDrag and onDrag to allow preventDefault later if needed
    this.handleTarget.addEventListener("touchstart", this.startDrag.bind(this), { passive: false })
    document.addEventListener("touchend", this.stopDrag.bind(this))
    document.addEventListener("touchmove", this.onDrag.bind(this), { passive: false })
  }

  // Helper to get the X coordinate from either mouse or touch events
  getEventX(e) {
    // Check for `touches` array (from TouchEvent) or fall back to pageX (from MouseEvent)
    return e.touches ? e.touches[0].pageX : e.pageX
  }

  startDrag(e) {
    // Prevent default touch/click behavior (e.g., scrolling, text selection)
    // IMPORTANT: Only do this on touch/click events that start the drag
    if (e.cancelable) {
        e.preventDefault()
    }

    this.dragging = true

    // **FIXED:** Use getEventX for touch/mouse compatibility
    const eventX = this.getEventX(e)

    // Calculate the offset from where the handle was clicked/touched
    this.startX = eventX - this.handleTarget.offsetLeft
  }

  onDrag(e) {
    if (!this.dragging) return

    // Prevent default behavior (like scrolling on touch devices) while dragging
    if (e.cancelable) {
        e.preventDefault()
    }

    // **FIXED:** Use getEventX for touch/mouse compatibility
    const eventX = this.getEventX(e)

    // Calculate the new X position
    let newX = eventX - this.startX

    // Clamp values
    if (newX < 0) newX = 0
    if (newX > this.maxX) newX = this.maxX

    this.handleTarget.style.transform = `translateX(${newX}px)`

    if (newX >= this.maxX) {
      this.confirm()
      this.stopDrag()
    }
  }

  stopDrag() {
    if (!this.dragging) return
    this.dragging = false
    this.handleTarget.style.transform = "translateX(0)" // reset
  }

  confirm() {
    console.log("✅ Confirmed!")

    // update hidden field
    this.hiddenTarget.value = "true"

    // submit form automatically
    // The conditional check is a safety measure if you plan to reuse this on a page without a form
    if (this.hiddenTarget.form) {
        this.hiddenTarget.form.requestSubmit()
    }
  }
}
