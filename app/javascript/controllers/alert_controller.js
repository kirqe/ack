import { Controller } from "stimulus"

export default class extends Controller {
  // static targets = ["dialog", "closeBtn"]

  closeDialog() {
    this.element.remove()
  }
}