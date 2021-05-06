import { Controller } from 'stimulus'
import Tribute from 'tributejs'
import Editor from '@toast-ui/editor'

export default class extends Controller {
  static targets = ['editor', 'textarea', 'submit']
  static values = { users: Array }

  connect () {
    var index = 0
    const editors = []

    while (index < this.editorTargets.length) {
      console.log(index)
      console.log(this.editorTargets[index])
      console.log(this.textareaTargets[index])

      editors[index] = new Editor({
        el: this.editorTargets[index],
        height: 'auto',
        initialEditType: 'wysiwyg',
        initialValue: this.textareaTargets[index].value,
        previewStyle: 'tab',
        extendedAutolinks: false
      })

      editors[index].toUpdate = this.textareaTargets[index]
      index++
    }

    this.submitTarget.onclick = function () {
      console.log(editors)
      var index = 0
      while (index < editors.length) {
        editors[index].toUpdate.value = editors[index].getMarkdown()
        editors[index].reset()
        index++
      }
    }

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
  }
}

