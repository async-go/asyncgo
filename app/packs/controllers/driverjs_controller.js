import { Controller } from 'stimulus'
import Driver from 'driver.js/dist/driver.min.js'


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
      console.log('Hello');
      const driver = new Driver();
      driver.highlight({
          element: '#notifications',
          popover: {
              title: 'Title',
              description: 'Description',
          }
      });
      driver.start();
  }
}
