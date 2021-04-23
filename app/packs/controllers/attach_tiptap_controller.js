import { Controller } from 'stimulus'
import { Editor } from '@tiptap/core'
import { defaultExtensions } from '@tiptap/starter-kit'

export default class extends Controller {
    static targets = ['textarea']

    initialize () {
      window.tiptap = {};
    }

    connect () {
      if (this.textareaTarget.id === "") {
        throw "Error: no ID provided for tiptap editor";
      }
      window.tiptap[this.textareaTarget.id] = new Editor({
        element: this.textareaTarget,
        extensions: defaultExtensions(),
        content: '<p>Hello world!</p>'
      })
    }
}
