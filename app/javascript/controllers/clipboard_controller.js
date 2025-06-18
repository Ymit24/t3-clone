import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="clipboard"
export default class extends Controller {
  static targets = ["code"];
  connect() {
  }

  copy(event) {
    const text = this.codeTarget.textContent;
    navigator.clipboard.writeText(text);
    console.log("copied to clipboard", text);
  }
}
