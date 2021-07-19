import { isEqual }  from 'lodash'
// const uploads = Storage.new("uploads")
// uploads.add("post_form", {signed_id: "blob.signed_id"})
// uploads.get("form_a") => {key: "", object: ...}
export default class Storage {
  constructor(key) {
    this.key = key
    this.entries = this.all()
  }

  all() {
    let obj = localStorage.getItem(this.key)
    return JSON.parse(obj) || []
  }

  add(key, object) {    
    const newEntry = { key,  object }
    let alreadyExists = false
  
    this.entries.forEach((entry) => {
      if (isEqual(entry, newEntry)) {
        alreadyExists = true
      }
    })
    
    if (!alreadyExists) {
      this.entries.push(newEntry)
      this._save()
    }
  }

  update(key, object) {
    let entry = this.get(key)
    entry.object = object
    this._save()
  }

  addOrUpdate(key, object) {
    let obj = this.get(key)
    if (obj == null) {
      this.add(key, object)      
    } else {
      this.update(key, object)
    }
  }

  get(key) {
    return this.entries.find((entry) => entry.key == key)    
  }

  remove(key) {
    this.entries = this.entries.filter((entry) => entry.key != key)
    this._save()
  }

  reload() {
    this.entries = this.all()
    this._save()
  }

  _save() {
    localStorage.setItem(this.key, JSON.stringify(this.entries))
  }
}