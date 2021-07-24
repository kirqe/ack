import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["form", "wrapper"]

  connect() {
    console.log("connected boards")
  }

  onPostSuccess(e) {
    let [response, status, xhr] = e.detail
    Turbolinks.clearCache()
    Turbolinks.visit("/")
  }

  onPostError(e) {
    let [response, status, xhr] = e.detail    
    this.wrapperTarget.outerHTML = response.formWithErrors
  }
}