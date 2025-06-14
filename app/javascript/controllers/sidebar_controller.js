import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="sidebar"
export default class extends Controller {
    static targets = ["sidebar", "toggleButton"]

    connect() {
        this.update()
    }

    toggle() {
        this.sidebarTarget.classList.toggle("collapsed")
        this.update()
    }

    update() {
        const isCollapsed = this.sidebarTarget.dataset.collapsed === "true"
        this.toggleButtonTarget.dataset.collapsed = !isCollapsed
        this.sidebarTarget.dataset.collapsed = !isCollapsed
    }
} 