import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="share-modal"
export default class extends Controller {
  copyLink() {
    navigator.clipboard.writeText(this.element.dataset.shareUrl);
  }
}
