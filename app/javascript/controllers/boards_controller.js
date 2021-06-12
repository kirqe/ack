import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["boards", "newBoardBtn", "newBoardDialog"]

  connect() {
    console.log("connected boards")
  }

  openDialog(e) {
    e.preventDefault()
    this.newBoardDialogTarget.classList.toggle("hidden")
  }
}