import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["form", "wrapper"]

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