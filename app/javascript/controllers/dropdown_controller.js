import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["btn", "menu"]

  toggle(e) {
    e.preventDefault()
    this.menuTarget.classList.toggle("block")
  }
}