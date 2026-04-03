import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    registerable: Boolean
  }

  connect() {
    const initialMode = this.element.classList.contains("is-register") ? "register" : "login"
    this.applyMode(initialMode)
  }

  toggle(event) {
    this.applyMode(event.currentTarget.dataset.authToggleTarget)
  }

  applyMode(mode) {
    const currentMode = this.registerableValue && mode === "register" ? "register" : "login"
    const isRegister = currentMode === "register"

    this.element.classList.toggle("is-register", isRegister)
    this.element.classList.toggle("is-login", !isRegister)

    this.element.querySelectorAll("[data-auth-toggle-target]").forEach((button) => {
      const isActive = button.dataset.authToggleTarget === currentMode
      button.classList.toggle("active", isActive)
      button.setAttribute("aria-pressed", isActive.toString())
    })
  }
}
