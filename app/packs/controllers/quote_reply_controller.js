import { Controller } from 'stimulus'

export default class extends Controller {
  static targets = ['content', 'authoremail', 'date']

  quote () {
    const content = this.contentTarget.innerText
    const date = this.dateTarget.innerText
    const authorEmail = this.authoremailTarget.innerText.trim()

    const quotedReply = content.split('\n').map(line => `> ${line}`).join('\n')

    const editor = document.querySelectorAll('[data-target="comment_body"]:last-of-type')[0].editorObj
    editor.setMarkdown(`On ${date} @${authorEmail} wrote:\n${quotedReply}\n\n`)
    editor.focus()
    editor.moveCursorToEnd()
  }
}
