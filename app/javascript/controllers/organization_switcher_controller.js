import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="organization-switcher"
export default class extends Controller {
  static targets = ["trigger", "menu"]
  connect() {
  }

  toggle() {
    this.isOpen ? this.close() : this.open()
  }

  open() {
    this.menuTarget.hidden = false
    this.triggerTarget.setAttribute("aria-expanded", "true")
  }

  close() {
    if (!this.isOpen) return
    this.menuTarget.hidden = true
    this.triggerTarget.setAttribute("aria-expanded", "false")
  }

  closeOnOutside(event) {
    if (!this.element.contains(event.target)) {
      this.close();
    }
  }

  get isOpen() {
    return this.triggerTarget.getAttribute("aria-expanded") == "true"
  }
}
