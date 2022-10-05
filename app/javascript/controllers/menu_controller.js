import { Controller } from "@hotwired/stimulus"

import { toggle } from 'el-transition'

// Connects to data-controller="menu"
export default class extends Controller {
  static targets = [
    "desktopMenu",
    "mobileMenu"
  ]

  connect() {
    console.log("menu controller connected")
    console.log("toggle", toggle);
  }

  toggleDesktopMenu() {
    toggle(this.desktopMenuTarget)
  }

  toggleMobileMenu() {
    toggle(this.mobileMenuTarget)
  }

}
