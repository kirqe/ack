import { Controller } from "stimulus"
import { DirectUpload } from "@rails/activestorage"

import Quill from 'quill/dist/quill.js';
import QuillResize from 'quill-resize-module';
Quill.register('modules/resize', QuillResize);
const Delta = Quill.import('delta');

import Storage from "packs/storage"

import { ImageFormat, Video } from "packs/blots"

Video.blotName = 'simpleVideo'
Video.tagName = 'video'

Quill.register(ImageFormat, true);
Quill.register(Video);


export default class extends Controller {
  // textArea is the f.text_area of a form
  // editor should be inside of the wrapperTarget
  static targets = ["editor", "textArea", "wrapper"]
  
  initialize(){
    this.postStorage = new Storage("post")
  }

  connect() {
    if (this.hasEditorTarget) {
      this.quill = new Quill(this.editorTarget, {
        modules: {
          toolbar: this.toolBarOptions,
          resize: {
            modules: [ 'Resize', 'DisplaySize', 'Toolbar']          
          }
        },
        placeholder: 'Text (optional)',
        theme: 'snow'
      });

      this.quill.getModule('toolbar').addHandler('image', () => {
        this.importImage();
      });

      this.quill.getModule('toolbar').addHandler('video', () => {
        this.importVideo()
      });

      // populate editor with textarea value when the form has errors
      this.quill.root.innerHTML = this.textAreaTarget.value

      // disallow pasting images
      this.quill.clipboard.addMatcher('img', (node, delta) => {    
                  
        return new Delta()//.insert({image: node.src});      
      });

      // attach images to to the form to persist then on active storage cleanup
      this.quill.on('text-change', (delta, oldDelta, source) => {  
        document.querySelectorAll('img[src^="data:"]').forEach(el => el.remove())

        let uploads = this.wrapperTarget.querySelectorAll("*[src*='blob']")
        let attachedUploads = document.querySelectorAll(".h-upload")
 
        if (uploads.length != attachedUploads.length) {
          this._removeAllAttachedUploads()
          uploads.forEach(upload => {
            let signed_id = upload.src.match(/blobs\/(.*)\//)[1]
  
            this._attachFileField(signed_id)
          })
          
        }

        this.textAreaTarget.value = this.quill.root.innerHTML;
        this.textAreaTarget.dispatchEvent(new Event('input'))
      })
    }
  }

  _removeAllAttachedUploads() {
    document.querySelectorAll('.h-upload').forEach(el => el.remove());
  }

  _isUploadExist(signed_id) {
    let attachedUploads = document.querySelectorAll('.h-upload hidden')

    if (attachedUploads != null) {
      let found = attachedUploads.find(u => u.value == signed_id)
      if (found) {
        return true 
      }
    }
    return false
  }

  _attachFileField(signed_id) {
    if(document.querySelector(`input.h-upload[value=${CSS.escape(signed_id)}]`)) {
      return
    }
    
    const field = document.createElement("input")
    field.setAttribute("class", "h-upload")
    // field.setAttribute("type", "hidden")
    field.setAttribute("value", signed_id)
    field.name = "post[files][]"
    this.wrapperTarget.insertAdjacentElement('afterend', field);          
  }

  importImage() {
    const input = document.createElement("input")
    input.setAttribute("type", "file");
    input.setAttribute("accept", "image/*")
    input.click()
    
    input.onchange = () => {
      const file = input.files[0];
  
      // Ensure only images are uploaded
      if (/^image\//.test(file.type)) {
        let range = this.quill.getSelection()
        let placeholderText = `[uploading... ${file.name}]`

        this.quill.insertText(range.index, placeholderText, "italic", true)
        this.uploadImage(range.index, placeholderText.length, file);                   
      } else {
        alert("Please select an image");
      }
    };    
  }

  importVideo() {
    const input = document.createElement("input")
    input.setAttribute("type", "file");
    input.setAttribute("accept", "video/*")
    input.click()
    
    input.onchange = () => {
      const file = input.files[0];
      console.log(file)
      
      if (/^video\//.test(file.type)) {
        let range = this.quill.getSelection()
        let placeholderText = `[uploading... ${file.name}]`

        this.quill.insertText(range.index, placeholderText, "italic", true)
        this.uploadVideo(range.index, placeholderText.length, file);                   
      } else {
        alert("Please select a video");
      }
    };    
  }

  uploadImage(placeholderStartIdx, placeholderEndIdx, file) {
    // var range = this.quill.getSelection();
    var upload = new DirectUpload(file, '/rails/active_storage/direct_uploads')
    upload.create((error, blob) => {
      if (error) {
        console.log(error)
        this.quill.deleteText(placeholderStartIdx, placeholderEndIdx)   
        this.quill.insertText(placeholderStartIdx, `[there was an error uploading ${file.name}]`, "italic", true)
      } else {
        this.quill.deleteText(placeholderStartIdx, placeholderEndIdx)   
        let url = `/rails/active_storage/blobs/${blob.signed_id}/${blob.filename}`

        this.quill.insertEmbed(placeholderStartIdx + 1, 'image', url);        
        this.quill.insertEmbed(placeholderStartIdx, 'block', '<p><br></p>'); 
      }
    });
  }


  uploadVideo(placeholderStartIdx, placeholderEndIdx, file) {
    // var range = this.quill.getSelection();
    var upload = new DirectUpload(file, '/rails/active_storage/direct_uploads')
    upload.create((error, blob) => {
      if (error) {
        console.log(error)
        this.quill.deleteText(placeholderStartIdx, placeholderEndIdx)   
        this.quill.insertText(placeholderStartIdx, `[there was an error uploading ${file.name}]`, "italic", true)
      } else {
        this.quill.deleteText(placeholderStartIdx, placeholderEndIdx)   
        let url = `/rails/active_storage/blobs/${blob.signed_id}/${blob.filename}#t=0.5`

        this.quill.insertEmbed(placeholderStartIdx + 1, 'simpleVideo', {
          url,
          controls: 'controls',
          width: '100%',
          height: '100%'
        });        
        this.quill.insertEmbed(placeholderStartIdx, 'block', '<p><br></p>'); 
      }
    });
  }


  restoreDraft() {
    let latestPost = this.postStorage.get("latestPost")

    this.quill.root.innerHTML = latestPost.object.body
    this.textAreaTarget.dispatchEvent(new Event('input'))
  }  

  // duplicated toolbar fix caused by turbolinks
  // https://github.com/hotwired/stimulus/issues/104#issuecomment-365393601
  teardown() {
    this.wrapperTarget.innerHTML = "<div data-rich-text-target=\"editor\"></div>"
  }

  get toolBarOptions() {
    return  [
      ['bold', 'italic', 'strike'],
      ['link'],
      [{ 'header': 1 }, { 'header': 2 }], 
      [{ 'list': 'ordered'}, { 'list': 'bullet' }],
      ['blockquote', 'code-block'],
      [{ 'color': this.colors }, { 'background': this.colors }],
      ['image', 'video'],
    ];
  }

  get colors() {
    return [
      "#F9FAFB", "#F3F4F6", "#E5E7EB", "#D1D5DB", "#9CA3AF", "#6B7280", "#4B5563",
      "#FEF2F2", "#FEE2E2", "#FECACA", "#FCA5A5", "#F87171", "#EF4444", "#DC2626",
      "#FFFBEB", "#FEF3C7", "#FDE68A", "#FCD34D", "#FBBF24", "#F59E0B", "#D97706",
      "#ECFDF5", "#D1FAE5", "#A7F3D0", "#6EE7B7", "#34D399", "#10B981", "#059669",
      "#EFF6FF", "#DBEAFE", "#BFDBFE", "#93C5FD", "#60A5FA", "#3B82F6", "#2563EB",
      "#EEF2FF", "#E0E7FF", "#C7D2FE", "#A5B4FC", "#818CF8", "#6366F1", "#4F46E5",
      "#F5F3FF", "#EDE9FE", "#DDD6FE", "#C4B5FD", "#A78BFA", "#8B5CF6", "#7C3AED",
      "#FDF2F8", "#FCE7F3", "#FBCFE8", "#F9A8D4", "#F472B6", "#EC4899", "#DB2777",
    ]
  }
}