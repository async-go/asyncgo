import { Controller } from 'stimulus'
import { Editor } from '@tiptap/core'
import { defaultExtensions } from '@tiptap/starter-kit'

export default class extends Controller {
    static targets = ['textarea']

    connect () {
      const editor = new Editor({
        element: this.textareaTarget,
        extensions: defaultExtensions(),
        content: '<p>Hello world!</p>'
      })
    }
}
