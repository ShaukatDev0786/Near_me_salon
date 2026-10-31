import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["message", "progress"]

  connect() {
    this.timers = []

    this.messageTargets.forEach((message) => {
      const timer = setTimeout(() => {
        this.removeToast(message)
      }, 3000)

      this.timers.push(timer)
    })
  }

  dismiss(event) {
    const message = event.currentTarget.closest(".toast-message")

    if (message) {
      this.removeToast(message)
    }
  }

  removeToast(message) {
    if (!message || message.classList.contains("toast-leaving")) return

    message.classList.add("toast-leaving")

    message.addEventListener(
      "animationend",
      () => message.remove(),
      { once: true }
    )

    // Fallback in case the animation event does not fire.
    setTimeout(() => message.remove(), 400)
  }

  disconnect() {
    this.timers?.forEach((timer) => clearTimeout(timer))
  }
}
