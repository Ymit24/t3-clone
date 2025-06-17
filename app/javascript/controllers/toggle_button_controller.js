import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="toggle-button"
export default class extends Controller {
  static targets = ["checkbox"];

  connect() { }

  toggle() {
    this.checkboxTarget.checked = !this.checkboxTarget.checked;
    this.element.dataset.checked = this.checkboxTarget.checked;
  }
}
