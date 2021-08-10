import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["postFormWrapper", "togglePostFormBtn", "boardsNavWrapper"]

  connect() {
    if (this.hasPostFormWrapperTarget) {
      if (localStorage.getItem("isPostFormHidden") == "false") {
        this.postFormWrapperTarget.classList.remove("hidden")
        this.togglePostFormBtnTarget.text = "Close Form"
      } else {
        this.postFormWrapperTarget.classList.add("hidden")
      }
    }

    if (this.hasBoardsNavWrapperTarget) {
      let status = localStorage.getItem("isBoardsNavHidden")      
        if (status != null && status == "false") {
          this.boardsNavWrapperTarget.classList.remove("hidden")
        } else {
          this.boardsNavWrapperTarget.classList.add("hidden")
        }    
    }
  }

  toggleForm(e) {
    e.preventDefault()
    if (this.postFormWrapperTarget.classList.contains("hidden")) {
      localStorage.setItem("isPostFormHidden", "false")
    } else {
      localStorage.setItem("isPostFormHidden", "true")
    }
    this.postFormWrapperTarget.classList.toggle("hidden")
    
    this.togglePostFormBtnTarget.text = 
      (this.postFormWrapperTarget.classList.contains("hidden")) ? "Add" : "Close Form"
  }

  toggleBoardsNav(e) {
    e.preventDefault()
    if (this.boardsNavWrapperTarget.classList.contains("hidden")) {
      localStorage.setItem("isBoardsNavHidden", "false")
    } else {
      localStorage.setItem("isBoardsNavHidden", "true")
    }
    this.boardsNavWrapperTarget.classList.toggle("hidden")
  }
}
