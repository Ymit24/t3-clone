import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="prompt"
export default class extends Controller {
  connect() {
  }

  keydown(e) {
    if (e.keyCode === 13 && !e.shiftKey) {
      e.preventDefault();
      e.currentTarget.form.requestSubmit();
      return;
    }
  }

  resize(e) {
    const textarea = e.currentTarget;
    console.log("scroll height: ", textarea.scrollHeight, "clientHeight: ", textarea.clientHeight);
    textarea.style.height = "auto";
    textarea.style.height = textarea.scrollHeight + "px";
  }
}
