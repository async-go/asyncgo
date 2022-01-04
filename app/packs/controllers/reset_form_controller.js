import { Controller } from 'stimulus'

export default class extends Controller {
  reset () {
    this.element.querySelector('input[type=submit]').disabled = false
    this.element.querySelector("div[data-toastui-editor-target='editor']").editorObj.reset()
    this.element.reset()

    const formErrors = this.element.querySelector('ul')
    if (formErrors) {
      this.element.querySelector('ul').innerHTML = ''
    }
  }
}
