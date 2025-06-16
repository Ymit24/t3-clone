import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["element"]

  disable() {
    this.elementTargets.forEach(element => {
      element.disabled = true
    })
  }
} 