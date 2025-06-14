import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="scroll"
export default class extends Controller {
  static targets = ["container"]
  connect() {
    this.containerTarget.scrollTop = this.containerTarget.scrollHeight;
  }
}
