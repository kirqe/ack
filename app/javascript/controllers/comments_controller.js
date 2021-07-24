import { Controller } from "stimulus"
import Rails from "@rails/ujs"
import Storage from "packs/storage"

export default class extends Controller {
  static targets = [
    "form",
    "comments",
    "loader"
  ]
  
  static values = { url: String }

  initialize() {
    if (this.hasFormTarget) {
      this.isLoading = false
      this.ogForm = this.formTarget.outerHTML
    }
  }

  connect() {
    this.commentStorage = new Storage("comment")
    this._loadComments()
  }

  onPostSuccess(e) {
    let [response, status, xhr] = e.detail
    this.formTarget.outerHTML = this.ogForm

    this.commentsTarget.insertAdjacentHTML('afterbegin', response)
    this.commentStorage.reload()
    this.commentStorage.remove(this.formTarget.dataset.uploadsContainerIdValue)
  }

  onPostError(e) {
    let [response, status, xhr] = e.detail
    this.formTarget.outerHTML = response.formWithErrors
  }

  _loadComments() {
    this.isLoading = true
    this.loaderTarget.classList.remove("hidden")    

    Rails.ajax({
      type: "GET",
      url: this.urlValue,
      dataType: 'json',
      success: (data) => {
        this.isLoading = false
        this.loaderTarget.classList.add("hidden")

        this.commentsTarget.innerHTML = data.comments
      }
    })
  }
}