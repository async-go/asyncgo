import { Controller } from 'stimulus'
import Tribute from 'tributejs'
import Editor from '@toast-ui/editor'

export default class extends Controller {
  static targets = ['form', 'editor', 'textarea', 'submit']
  static values = { users: Array }

  connect () {
    const editor = new Editor({
      el: this.editorTarget,
      height: 'auto',
      initialEditType: 'wysiwyg',
      initialValue: this.textareaTarget.value,
      previewStyle: 'tab',
      extendedAutolinks: false
    })

    const tribute = new Tribute({
      values: [],
      selectTemplate: function (item) {
        return '@' + item.original.value
      }
    })
    tribute.attach(this.element.querySelectorAll('.tui-editor-contents'))

    const host = window.location.protocol + '//' + window.location.host
    const url = `${host}/teams/${window.gon.teamId}/users.json`
    window.fetch(url)
      .then(response => response.json())
      .then(function (data) {
        tribute.append(0, data)
      })

    editor.toUpdate = this.textareaTarget
    this.submitTarget.onclick = function () {
      editor.toUpdate.value = editor.getMarkdown()
      editor.reset()
    }
  }
}
