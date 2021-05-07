import { Controller } from 'stimulus'

export default class extends Controller {
  static targets = ['content', 'author', 'date']

  quote () {
    const content = this.contentTarget.innerText
    const date = this.dateTarget.innerText
    const author = this.authorTarget.innerText

    const quotedReply = content.split('\n').map(line => `> ${line}`).join('\n')

    const editor = document.getElementById('editor_comment_new')['editorObj']

    editor.setMarkdown("On " + date + " " + author + " wrote:\n" + quotedReply + "\n\n")
    window.scrollTo(0, document.body.scrollHeight);
    editor.focus()
    editor.moveCursorToEnd()
  }
}
