import { Controller } from 'stimulus'
import Tribute from 'tributejs'
import Editor from '@toast-ui/editor';

export default class extends Controller {
  static targets = [ "form", "editor", "textarea", "submit" ]
  static values = { users: Array }

  initialize () {
    const controller = this

    const host = window.location.protocol + '//' + window.location.host
    const url = `${host}/teams/${window.gon.teamId}/users.json`
    window.fetch(url)
      .then(response => response.json())
      .then(function (data) {
        controller.usersValue = data
      })
  }

  connect () {
    const editor = new Editor({
      el: this.editorTarget,
      height: 'auto',
      initialEditType: 'wysiwyg',
      initialValue: this.textareaTarget.value,
      previewStyle: 'tab'
    });

    const tribute = new Tribute({
      values: this.usersValue
    })
    tribute.attach(this.element.querySelectorAll('.tui-editor-contents'))

    editor.toUpdate = this.textareaTarget
    this.submitTarget.onclick = function(){
      editor.toUpdate.value = editor.getMarkdown()
      editor.reset()
    }
  }
}
