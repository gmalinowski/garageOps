import { Controller } from "@hotwired/stimulus"

const storageKey = "garageops.wireframe.location"

// Remember the preview selection across pages; sample records are not filtered.
export default class extends Controller {
  connect() {
    try {
      const savedLocation = localStorage.getItem(storageKey)
      if (Array.from(this.element.options).some(option => option.value === savedLocation)) {
        this.element.value = savedLocation
      }
    } catch {
      // The selector remains usable when browser storage is unavailable.
    }
  }

  change() {
    try {
      localStorage.setItem(storageKey, this.element.value)
    } catch {
      // Keep the current selection even when it cannot be remembered.
    }
  }
}
