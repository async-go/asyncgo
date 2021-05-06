import { Controller } from 'stimulus'
import he from 'he'

export default class extends Controller {
  static targets = ['content', 'author', 'date']

  quote () {
    const content = he.decode(this.contentTarget.innerText)
    const date = this.dateTarget.innerText
    const author = this.authorTarget.innerText

    const quotedReply = content.split('\n').map(line => `> ${line}`).join('\n')
    document.getElementById('comment_body').value = `On ${date} ${author} wrote\n${quotedReply}\n\n`

    document.getElementById('comment_body').focus()
  }
}
