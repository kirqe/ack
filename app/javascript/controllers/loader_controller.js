import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["indicator"]
  static values = { isLoading: String }

  connect() {
    this.isLoading()

    setInterval(()=>{
      this.isLoadingValue = "false"
      this.isLoading()
    }, 3000)
  }

  isLoading() {
    if (this.isLoadingValue == "false") {
      this.indicatorTarget.classList.add("hidden")
    } else {
      this.indicatorTarget.classList.remove("hidden")
    }
  }
}