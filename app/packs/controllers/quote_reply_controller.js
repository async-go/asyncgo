import { Controller } from 'stimulus'

export default class extends Controller {
  static targets = ['content', 'author', 'date']

  quote () {
    const content = this.contentTarget.innerText
    const date = this.dateTarget.innerText
    const author = this.authorTarget.innerText

    const quotedReply = content.split('\n').map(line => `> ${line}`).join('\n')
    document.querySelectorAll('.tui-editor-contents').value = `On ${date} ${author} wrote\n${quotedReply}\n\n`

    document.querySelectorAll('.tui-editor-contents').focus()
  }
}