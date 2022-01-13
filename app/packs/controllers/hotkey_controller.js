import { Controller } from '@hotwired/stimulus'
import { install, uninstall } from '@github/hotkey'

export default class extends Controller {
  connect () {
    if (this.disabled) return
    install(this.element)
  }

  disconnect () {
    uninstall(this.element)
  }

  get disabled () {
    return document.body.hasAttribute('data-hotkeys-disabled')
  }
}
