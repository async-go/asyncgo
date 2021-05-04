import { Controller } from 'stimulus'
import Editor from '@toast-ui/editor'

function preprocessor (markdown) {
  var mention_regex = /<span class="tribute-mention">(\S+)<\/span>/g
  return markdown.replace(mention_regex, '[$1](mailto:$1)');
};

export default class extends Controller {
  static targets = ['viewer', 'content']

  connect () {
    console.log(this.contentTarget)
    const viewer = Editor.factory({
      el: this.viewerTarget,
      viewer: true,
      height: 'auto',
      initialValue: preprocessor(this.contentTarget.innerHTML)
    })
  }
}
