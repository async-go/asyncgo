import { Controller } from 'stimulus'
import Editor from '@toast-ui/editor'

export default class extends Controller {
  static targets = ['editor']
  static values = { users: Array }

  _editor (target) {
    return new Editor({
      el: target,
      height: 'auto',
      initialEditType: 'wysiwyg',
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
  }

  connect () {
    this.editorTargets.forEach(editorTarget => {
      editorTarget.editorObj = this._editor(editorTarget)

      editorTarget.closest('form').addEventListener('submit', (event) => {
        event.target.elements.namedItem(editorTarget.dataset.target).value = editor.getMarkdown()
      }, false)
    })
  }
}
