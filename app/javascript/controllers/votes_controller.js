import { Controller } from "stimulus"
import Rails from "@rails/ujs"

export default class extends Controller {
  static targets = ["score", "voteBtn"]
  
  vote(e) {
    e.preventDefault()

    Rails.ajax({
      type: 'POST',
      url: this.voteBtnTarget.dataset.url,
      dataType: 'json',
      success: (data) => {        
        this.voteBtnTarget.classList.toggle("voted")
        this.scoreTarget.innerText = data.votes
      }
    })
  }
}