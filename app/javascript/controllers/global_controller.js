import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["newPostForm", "toggleFormBtn"]

  connect() {
    if (this.hasNewPostFormTarget) {
      if (localStorage.getItem("isPostFormHidden") == "false") {
        this.newPostFormTarget.classList.remove("hidden")
        this.toggleFormBtnTarget.text = "Close Form"
      }
    }
  }

  toggleForm(e) {
    e.preventDefault()
    if (this.newPostFormTarget.classList.contains("hidden")) {
      localStorage.setItem("isPostFormHidden", "false")

    } else {
      localStorage.setItem("isPostFormHidden", "true")

    }
    this.newPostFormTarget.classList.toggle("hidden")
    
    this.toggleFormBtnTarget.text = 
      (this.newPostFormTarget.classList.contains("hidden")) ? "Add" : "Close Form"
    


  }
}