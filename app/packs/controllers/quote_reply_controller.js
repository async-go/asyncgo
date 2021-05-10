import { Controller } from 'stimulus'

export default class extends Controller {
  static targets = ['content', 'authoremail', 'date']

  quote () {
    const content = this.contentTarget.innerText
    const date = this.dateTarget.innerText
    const authorEmail = this.authoremailTarget.innerText.trim()

    const quotedReply = content.split('\n').map(line => `> ${line}`).join('\n')
    document.getElementById('comment_body').value = `On ${date} @${authorEmail} wrote:\n${quotedReply}\n\n`

    document.getElementById('comment_body').focus()
  }
}
