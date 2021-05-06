import { Controller } from 'stimulus'

function decodeHtml(html) {
    var txt = document.createElement("textarea");
    txt.innerHTML = html;
    return txt.value;
}

export default class extends Controller {
  static targets = ['content', 'author', 'date']

  quote () {
    const content = decodeHtml(this.contentTarget.innerText)
    const date = this.dateTarget.innerText
    const author = this.authorTarget.innerText

    const quotedReply = content.split('\n').map(line => `> ${line}`).join('\n')
    document.getElementById('comment_body').value = `On ${date} ${author} wrote\n${quotedReply}\n\n`

    document.getElementById('comment_body').focus()
  }
}
