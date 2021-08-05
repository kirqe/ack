import { Controller } from "stimulus"
import Rails from "@rails/ujs"
import { DirectUpload } from "@rails/activestorage"
import Storage from "packs/storage"
export default class extends Controller {
  static targets = [
    "form",
    "replies",
    "loader",
    "formWrapper",
    // "textArea",
    "repliesWrapper",
    "toggleFormBtn",
    "expandRepliesBtn",
    "collapseRepliesBtn",
    // "attachments"
  ]

  static values = { url: String, expanded: Boolean }

  initialize() {
    if (this.hasFormTarget) {
      this.isLoading = false
      this.ogForm = this.formTarget.outerHTML
      this.isFormOpen = false
      this.isRepliesExpanded = false
      this.isRepliesLoaded = false    
    }
  }

  connect() {
    //this._loadReplies()    
    this.commentStorage = new Storage("comment")
    if (this.expandedValue) {
      this.repliesWrapperTarget.classList.remove("hidden")
      this.expandRepliesBtnTarget.classList.add("hidden")
      this.isRepliesExpanded = true
    } else {
      this.repliesWrapperTarget.classList.add("hidden")
      this.expandRepliesBtnTarget.classList.remove("hidden")
      this.isRepliesExpanded = false
    }
  }

  toggleForm(e) {
    e.preventDefault()
    this.formWrapperTarget.classList.toggle("hidden")
    this.isFormOpen = !this.isFormOpen

    this.toggleFormBtnTarget.innerText = 
      (this.isFormOpen) ? "close reply form" : "reply"    
  }

  toggleReplies(e) {
    e.preventDefault()
    this.repliesWrapperTarget.classList.toggle("hidden")
    this.isRepliesExpanded = !this.isRepliesExpanded
  }

  collapseReplies(e) {
    e.preventDefault()
    this.repliesWrapperTarget.classList.add("hidden")
    this.expandRepliesBtnTarget.classList.remove("hidden")
    this.isRepliesExpanded = false
  }

  expandReplies(e) {
    e.preventDefault()
    this._loadReplies()
    this.repliesWrapperTarget.classList.remove("hidden")
    this.expandRepliesBtnTarget.classList.add("hidden")
    this.isRepliesExpanded = true
  }

  onPostSuccess(e) {
    let [response, status, xhr] = e.detail
    this.formTarget.outerHTML = this.ogForm
    this.repliesTarget.insertAdjacentHTML('beforeend', response)
    this.toggleForm(e)
    this.expandReplies(e)
    // console.log(this.formTarget.uploadsContainerIdValue)
    this.commentStorage.remove(this.formTarget.dataset.uploadsContainerIdValue)
  }

  onPostError(e) {
    let [response, status, xhr] = e.detail
    if (xhr.status == 403) {
      dispatchEvent(new CustomEvent("notice", {
        detail: {
          message: response.notice
        }
      }))
    } else {
      this.formTarget.outerHTML = response.formWithErrors
    }
  }

  _loadReplies() {
    if (!this.isRepliesLoaded) {
      this.isLoading = true
      this.loaderTarget.classList.remove("hidden")    
    
      Rails.ajax({
        type: "GET",
        url: this.urlValue,
        dataType: 'json',
        success: (data) => {
          this.isRepliesLoaded = true
          this.isLoading = false        
          this.loaderTarget.classList.add("hidden")
          this.repliesTarget.innerHTML = data.replies
        }
      })
    }    
  }
}