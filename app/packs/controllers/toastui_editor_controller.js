import { Controller } from 'stimulus'
import Editor from '@toast-ui/editor';

export default class extends Controller {
  static targets = [ "editor", "textarea", "submit" ]

  connect () {
    const editor = new Editor({
      el: this.editorTarget,
      height: 'auto',
      initialEditType: 'wysiwyg',
      initialValue: this.textareaTarget.value,
      previewStyle: 'tab'
    });
    editor.toUpdate = this.textareaTarget
    this.submitTarget.onclick = function(){
      editor.toUpdate.value = editor.getMarkdown()
      editor.reset()
    }
  }
}
