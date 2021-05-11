import { Controller } from 'stimulus'

export default class extends Controller {
  static targets = ['content', 'authoremail', 'date']

  quote () {
    const content = this.contentTarget.innerText
    const date = this.dateTarget.innerText
    const authorEmail = this.authoremailTarget.innerText.trim()

    const quotedReply = content.split('\n').map(line => `> ${line}`).join('\n')

    const editor = document.getElementById('editor_comment_new').editorObj
    editor.setMarkdown('On ' + date + ' @' + authorEmail + ' wrote:\n' + quotedReply + '\n\n')
    window.scrollTo(0, document.body.scrollHeight)
    editor.focus()
    editor.moveCursorToEnd()
  }
}
