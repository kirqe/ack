import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["boards", "currentBoard"]

  connect() {
    if (this.hasCurrentBoardTarget) {
      let container = this.boardsTarget.getBoundingClientRect()
      let rect = this.boardsTarget.querySelector(".current").getBoundingClientRect()
      
      if (rect.x < container.left) {
        this.boardsTarget.scrollTo((container.left + rect.width), 0)
      } 
      if (rect.x + 10 > container.right) { 
        console.log(container)
        this.boardsTarget.scrollTo((rect.x + rect.width), 0)    
      }
    }
  }
}

