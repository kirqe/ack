import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["dialog"]

  openDialog(e) {
    e.preventDefault()
    this.dialogTarget.classList.toggle("block")
  }
} 