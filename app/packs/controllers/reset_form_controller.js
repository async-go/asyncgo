import { Controller } from 'stimulus'

export default class extends Controller {
  reset () {
    this.element.querySelector('input[type=submit]').disabled = false
    this.element.querySelector('ul').innerHTML = ""
    this.element.reset()
  }
}
