import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["searchForm"]
  static values = { term: String }

  connect() {    
    if (this.hasTermValue && this.termValue !== "") {
      this.searchFormTarget.classList.remove("hidden")
    }    
  }

  toggleForm(e) {
    e.preventDefault()
    this.searchFormTarget.classList.toggle("hidden")
  }
}