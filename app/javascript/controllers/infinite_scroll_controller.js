import { Controller } from "stimulus"
import Rails from "@rails/ujs"
export default class extends Controller {
  static targets = ["pagination", "posts"]

  connect() {
     console.log(window.document.body)
  }
  initialize() {
    this.loading = false;
  }

  scroll() {
    let next_page = this.paginationTarget.querySelector("a[rel='next']")
    if(next_page == null ) { return }
    let url = next_page.href

    var body = document.body
    var html = document.documentElement

    var height = Math.max(body.scrollHeight, body.offsetHeight, html.clientHeight, html.scrollHeight, html.offsetHeight)
    
    if (window.pageYOffset >= height - window.innerHeight - 100) {
      if (this.loading) { return }
      this.loadMore(url)      
    }
  }

  loadMore(url) {
    this.loading = true;
    Rails.ajax({
      type: 'GET',
      url: url,
      dataType: 'json',
      success: (data) => {
        this.postsTarget.insertAdjacentHTML('beforeend', data.posts)
        this.paginationTarget.innerHTML = data.pagination
        this.loading = false;
      }
    })
  }

}