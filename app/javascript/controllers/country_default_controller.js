import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="country-default"
export default class extends Controller {
  connect() {
    if (this.element.value) return

    for (const language of navigator.languages) {
      const region = this.regionFor(language)

      if (region && this.hasOption(region)) {
        this.element.value = region
        break
      }
    }

  }

  regionFor(language) {
    try {
      const locale = new Intl.Locale(language)

      return locale.region || locale.maximize().region
    } catch {
      return null
    }
  }

  hasOption(value) {
    return Array.from(this.element.options).some(
      option => option.value === value
    )
  }
}
