import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="toggle"
export default class extends Controller {
    static targets = ["toggleable"]

    toggle() {
      console.log("toggling...");
      console.log("toggleables: ", this.toggleableTargets);
      this.toggleableTargets.forEach((target) => {
        console.log("toggling...", target);
        target.dataset.toggled = !(target.dataset.toggled === "true");
      });
    }
} 
