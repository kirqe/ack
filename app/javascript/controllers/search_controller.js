import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["searchForm"]

  toggleForm(e) {
    e.preventDefault()
    this.searchFormTarget.classList.toggle("hidden")
  }
}