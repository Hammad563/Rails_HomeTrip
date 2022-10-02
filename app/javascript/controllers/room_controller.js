import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="room"
export default class extends Controller {
  static targets = [
    'bedTemplate',
    'beds'
  ]
  connect() {
  }

  addBed(e) {
    e.preventDefault();
    this.bedsTarget.insertAdjacentHTML(
      'beforeend',
      this.bedTemplateTarget.innerHTML
    )
  }


}
