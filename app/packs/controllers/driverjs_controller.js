import { Controller } from 'stimulus'
import Driver from 'driver.js/dist/driver.min.js'

export default class extends Controller {
  demo () {
    console.log('Hello')
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
