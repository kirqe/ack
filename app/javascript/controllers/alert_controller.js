import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["message"]
  
  connect() {
    if (this.hasMessageTarget) {      
      self.addEventListener("notice", (e) => {
        this.messageTarget.innerText = e.detail.message
        this.element.classList.remove("hidden")
        window.scrollTo(0, 0);
      })
    }
  }
  closeDialog() {
    this.element.remove()
  }

  hideDialog() {
    this.element.classList.add("hidden")
    this.messageTarget.innerText = ""
  }
}