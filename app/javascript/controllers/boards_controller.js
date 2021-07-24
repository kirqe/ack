import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["boards", "newBoardBtn", "newBoardDialog"]
  
  openDialog(e) {
    e.preventDefault()
    this.newBoardDialogTarget.classList.toggle("hidden")
  }
}