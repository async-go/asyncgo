import { Controller } from 'stimulus'
import Editor from '@toast-ui/editor';

export default class extends Controller {
  static targets = [ "viewer", "content" ]

  connect () {
    console.log("Attaching")
    console.log(this.viewerTarget)
    console.log(this.contentTarget)
    const viewer = Editor.factory({
      el: this.viewerTarget,
      viewer: true,
      height: 'auto',
      initialValue: this.contentTarget.value,
    });
    this.viewerTarget.classList.remove("d-none")
  }
}
