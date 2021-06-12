import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["postFormWrapper", "togglePostFormBtn"]
  // postForm
  // boardForm

  connect() {
    if (this.hasPostFormWrapperTarget) {
      if (localStorage.getItem("isPostFormHidden") == "false") {
        this.postFormWrapperTarget.classList.remove("hidden")
        this.togglePostFormBtnTarget.text = "Close Form"
      } else {
        this.postFormWrapperTarget.classList.add("hidden")
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

  toggleSettings(e) {
    e.preventDefault()
  }
}
