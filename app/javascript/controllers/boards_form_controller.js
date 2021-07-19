import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["form"]

  connect() {
    console.log("connected boards")
  }

  onPostSuccess(e) {
    let [response, status, xhr] = e.detail
    window.location = "/"
  }

  onPostError(e) {
    let [response, status, xhr] = e.detail    
    this.formTarget.innerHTML = response.formWithErrors
  }
}