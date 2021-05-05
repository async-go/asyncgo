import { Controller } from 'stimulus'

export default class extends Controller {
  static targets = [ "content", "author", "date" ]

  quote () {
    const content = this.contentTarget.innerText
    const date = this.dateTarget.innerText
    const author = this.authorTarget.innerText
    const commentbox = document.getElementById('comment_body')
    var lines = content.split('\n')
    commentbox.value += 'On ' + date + ' ' + author + ' wrote:\n'
    lines.forEach(element => commentbox.value += '> ' + element + '\n');
    commentbox.value += '\n'
    document.getElementById('comment_body').focus()
  }
}
