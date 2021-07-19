import { Controller } from "stimulus"
import debounce from 'lodash/debounce'
import Storage from "packs/storage"

export default class extends Controller {
  static targets = ["wrapper", "form", 
                    "name", "url", "body", 
                    "indicator", "characterCount",
                    "submitBtn", "restoreBtn"]

  connect() {
    console.log("form controller")
    
  }

  initialize(){
    this.postStorage = new Storage("post")

    if (this.hasFormTarget) {
      this.backUp = debounce(this.backUp, 2000).bind(this)
    }
  }

  onPostSuccess(e) {
    this.wrapperTarget.classList.add("hidden") 
    // localStorage.removeItem("latestPost")
    this.postStorage.remove("latestPost")
    let [response, status, xhr] = e.detail
    console.log(response)
    window.location = response.url
  }

  onPostError(e) {
    let [response, status, xhr] = e.detail
    console.log(response)
    this.wrapperTarget.outerHTML = response.formWithErrors
    this.formTarget.classList.remove("hidden") // by default the form is hidden
    this.submitBtnTarget.classList.remove("submitted")
  }

  // save current post to the localStorage
  backUp(e) {
    this.indicatorTarget.classList.add("saving")

    let latestPost = {
      name: this.nameTarget.value,
      url: this.urlTarget.value,
      body: this.bodyTarget.value
    }
    this.postStorage.addOrUpdate("latestPost", latestPost)
    // localStorage.setItem("latestPost", JSON.stringify(latestPost))
    setTimeout(() => {
      this.indicatorTarget.classList.remove("saving")
    }, 1000)
  }

  // restore latest post from the localStorage
  restoreDraft(e) {
    e.preventDefault()
    window.dispatchEvent(new CustomEvent("restore-draft"))
  } 
}