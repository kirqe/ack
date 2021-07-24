import { Controller } from "stimulus"
import { DirectUpload } from "@rails/activestorage"
import Storage from "packs/storage"

export default class extends Controller {
  static targets = ["dropzone", "attachments"]
  static values = { containerId: String }

  initialize() {
    this.uploadsLimit = 4
    this.maxSize = 400000000
    this.commentStorage = new Storage("comment")
    this.totalSize = 0
    this.uploads = {
      entries: []
    }
  }

  connect() {
    this.restoreUploads()
  }

  onDrag(e) {
    e.preventDefault()
    this.dropzoneTarget.classList.toggle("dragging")
  }

  onDragOver(e) {
    e.preventDefault()    
  }

  onDrop(e) {
    e.preventDefault()
    this.dropzoneTarget.classList.remove("dragging")

    var files = Array.from(e.dataTransfer.items)

    if (files.length > this.uploadsLimit || this.uploadsLimit == 0) {
      alert("Please don't upload more than 4 files. Thank you! <3")
      return
    }

    let total = files.reduce((total, item) => total + item.getAsFile().size, 0)

    if (total > this.maxSize) {
      alert("The total size of the uploads is to big.")
      return
    }


    files.forEach((item) => {
      if (item.kind == 'file' && this.uploadsLimit > 0) {
        var file = item.getAsFile();

        this._upload(file)         
      }        
    })
  }

  _upload(file) {
    const upload = new DirectUpload(file, '/rails/active_storage/direct_uploads')
    const { id, _file } = upload
    this.attachmentsTarget.classList.add("has-attachments")
    this.attachmentsTarget.insertAdjacentHTML("beforeend", `<a href="#" id="direct-upload-${id}">[uploading... ${file.name}]</a>`)

    upload.create((error, blob) => {
      if (error) {
        document.getElementById(`direct-upload-${id}`).remove()
      } else {
        let url = `/rails/active_storage/blobs/${blob.signed_id}/${blob.filename}`

        let upload = {
          signed_id: blob.signed_id,
          url: url,
          file_name: file.name
        }

        let attachment = this.uploadItemComponent(upload)

        this.uploads.entries.push(upload)
        this.commentStorage.reload()
        this.commentStorage.addOrUpdate(this.containerIdValue, this.uploads)
        this.uploadsLimit -= 1

        this.toggleAttachments()
        document.getElementById(`direct-upload-${id}`).outerHTML = attachment    
      }
    });
  }

  restoreUploads() {
    let commentUploads = this.commentStorage.get(this.containerIdValue)

    if (commentUploads != null) {
      this.toggleAttachments()
      commentUploads.object.entries.forEach(entry => {
        this.uploads.entries.push(entry)
        this.attachmentsTarget.insertAdjacentHTML("beforeend", this.uploadItemComponent(entry))
        this.uploadsLimit -= 1
      })      
    }
  }

  deleteAttachment(e) {
    e.preventDefault()
    let uploads = this.commentStorage.get(this.containerIdValue)
    let toDelete = e.target.closest("a").dataset.signedId
    let newEntries = uploads.object.entries.filter(entry => entry.signed_id != toDelete)

    if (newEntries.length > 0) {
      this.uploads.entries = newEntries
      this.commentStorage.addOrUpdate(this.containerIdValue, this.uploads)
    } else {
      this.commentStorage.remove(this.containerIdValue)
    }
    
    e.currentTarget.parentNode.remove();
    this.uploadsLimit += 1     
    this.toggleAttachments()
  }

  teardown() {
    this.attachmentsTarget.innerHTML = "<div class=\"attachments \" data-uploads-target=\"attachments\"></div>"
  }

  toggleAttachments() {
    let commentUploads = this.commentStorage.get(this.containerIdValue)

    if (commentUploads.object.entries.length > 0) {
      this.attachmentsTarget.classList.add("has-attachments")
    } else {
      this.attachmentsTarget.classList.remove("has-attachments")
    }
  }

  uploadItemComponent(upload) {
    let {signed_id, url, file_name} = upload

    return `
      <div class="flex items-center attachment">
        <input type="hidden" value="${signed_id}" name="comment[files][]" />
        <a href="#" data-action="click->uploads#deleteAttachment" data-signed-id="${signed_id}">
          <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 mr-1 text-red-500" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
          </svg>    
        </a>
        <a href="${url}" class="flex items-center">  
          <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 mr-1" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15.172 7l-6.586 6.586a2 2 0 102.828 2.828l6.414-6.586a4 4 0 00-5.656-5.656l-6.415 6.585a6 6 0 108.486 8.486L20.5 13" />
          </svg> ${file_name}
        </a>
      </div>
    `
  }
}
