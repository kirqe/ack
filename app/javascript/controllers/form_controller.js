import { Controller } from "stimulus"
import Turbolinks from "turbolinks"

import debounce from 'lodash/debounce'

export default class extends Controller {
  static targets = ["formWrapper", "newPostForm", 
                    "name", "url", "body", 
                    "indicator", "characterCount",
                    "submitButton"]

  connect() {
    console.log("form controller")
  }

  initialize(){
    if (this.hasNewPostFormTarget) {
      this.backUp = debounce(this.backUp, 2000).bind(this)

      this.loadDataFromLocalStorage()
      this.countCharacters()
    }
  }

  onPostSuccess(event) {
    this.newPostFormTarget.classList.add("hidden") 
    localStorage.removeItem("latestPost")
    let [response, status, xhr] = event.detail;
    Turbolinks.visit(response.url, { action: "replace" })
  }

  onPostError(event) {
    let [response, status, xhr] = event.detail;
    console.log(response)
    this.formWrapperTarget.innerHTML = response
    this.countCharacters()
    this.newPostFormTarget.classList.remove("hidden") // by default the form is hidden
    this.submitButtonTarget.classList.remove("submitted")
  }

  // save current post to localStorage
  backUp(e) {
    this.indicatorTarget.classList.add("saving")

    let latestPost = {
      name: this.nameTarget.value,
      url: this.urlTarget.value,
      body: this.bodyTarget.value
    }
    
    localStorage.setItem("latestPost", JSON.stringify(latestPost))
    setTimeout(() => {
      this.indicatorTarget.classList.remove("saving")
    }, 2000)
  }

  // restore latest post on page reload
  loadDataFromLocalStorage() {
    if (localStorage.getItem("latestPost") !== null ) {
      let latestPost = JSON.parse(localStorage.getItem("latestPost"))
      
      this.nameTarget.value = latestPost.name
      this.urlTarget.value = latestPost.url
      this.bodyTarget.value = latestPost.body
    } 
  }

  // count text_area characters
  countCharacters(e) {          
    let body = this.bodyTarget.value
    let characters = body.length
    let charactersStr = 
      characters + ((characters >= 0 && characters != 1) ? " characters" : " character")

    let words = body.match(/\S+/g)
    let wordsStr = "0 words"
    if (words !== null) {
      wordsStr = 
        words.length + ((words.length >= 0 && words.length != 1) ? " words" : " word")
    }
     
    let lines = body.split(/\r\n|\r|\n/);
    let linesStr = "0 lines"
    if (lines !== null && characters > 0) {
      linesStr = 
        lines.length + ((lines.length >= 0 && lines.length != 1) ? " lines" : " line")
    }
     
    this.characterCountTarget.innerText = 
    linesStr + " \u2022 " + wordsStr + " \u2022 " + charactersStr
  }  
}