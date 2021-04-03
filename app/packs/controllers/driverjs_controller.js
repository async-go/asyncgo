import { Controller } from 'stimulus'
import Driver from 'driver.js/dist/driver.min.js'

export default class extends Controller {

  connect () {
    console.log('Hello connect')
  }

  demo () {
    console.log('Hello demo')
    const driver = new Driver()
    driver.highlight({
      element: '#notifications',
      popover: {
        title: 'Title',
        description: 'Description'
      }
    })
    driver.start()
  }
}
