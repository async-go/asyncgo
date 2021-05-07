import { Controller } from 'stimulus'
import Tribute from 'tributejs'
import Editor from '@toast-ui/editor'

export default class extends Controller {
  static targets = ['editor', 'textarea', 'submit', 'name']
  static values = { users: Array }

  connect () {
    let index = 0
    const editors = []

    window['tuieditors'] = {}

    // Create editors
    while (index < this.editorTargets.length) {
      editors[index] = new Editor({
        el: this.editorTargets[index],
        height: 'auto',
        initialEditType: 'wysiwyg',
        initialValue: this.textareaTargets[index].value,
        previewStyle: 'tab',
        toolbarItems: [
          'heading',
          'bold',
          'italic',
          'strike',
          'divider',
          'hr',
          'quote',
          'divider',
          'ul',
          'ol',
          'task',
          // 'indent',
          // 'outdent',
          'divider',
          'table',
          // 'image',
          'link',
          'divider',
          'code',
          'codeblock',
          'divider'
        ]
      })

      // Store target inside of editor so we can get it later
      editors[index].toUpdate = this.textareaTargets[index]

      // Store reference to each editor for tests and query replier
      this.editorTargets[index]['editorObj'] = editors[index]

      // Set accessibility titles
      const toolbar = editors[index].getUI().getToolbar()
      const buttons = toolbar.getItems().length
      let buttonindex = 0
      while (buttonindex < buttons) {
        const item = toolbar.getItem(buttonindex)
        item.el.title = item.getName()
        buttonindex++
      }

      index++
    }

    // Update submit button to copy content into hidden textareas
    this.submitTarget.onclick = function () {
      let index = 0
      while (index < editors.length) {
        editors[index].toUpdate.value = editors[index].getMarkdown()
        editors[index].reset()
        index++
      }
    }

    // Create and attach tribute to all editors
    const tribute = new Tribute({
      values: [],
      selectTemplate: function (item) {
        return '@' + item.original.value
      }
    })
    tribute.attach(this.element.querySelectorAll('.tui-editor-contents'))

    // Fetch users.json and update tribute
    const host = window.location.protocol + '//' + window.location.host
    const url = `${host}/teams/${window.gon.teamId}/users.json`
    window.fetch(url)
      .then(response => response.json())
      .then(function (data) {
        tribute.append(0, data)
      })
  }
}
