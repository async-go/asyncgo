import { Controller } from 'stimulus'
import Tribute from 'tributejs'

export default class extends Controller {
  static values = { users: Array }

  initialize () {
    const controller = this

    const host = window.location.protocol + '//' + window.location.host
    const url = `${host}/teams/${window.gon.teamId}/users.json`
    window.fetch(url)
      .then(response => response.json())
      .then(function (data) {
        controller.usersValue = data
      })
  }

  attach () {
    const tribute = new Tribute({
      values: this.usersValue
    })
    tribute.attach(this.element.getElementsByClassName('toastui-editor-contents'))
  }
}
