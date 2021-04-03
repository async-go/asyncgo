import { Controller } from 'stimulus'
import Driver from 'driver.js'

export default class extends Controller {
  connect () {
    console.log('Hello connect')
  }

  demo () {
    console.log('Hello demo')
    const driver = new Driver()

    driver.highlight({
      element: '#testelement',
      popover: {
        title: 'Notifications',
        description: 'This box shows you any notifications you might have. You can click on it to see them.'
      }
    })
    if (driver.isActivated) {
      console.log('Driver is active');
    }
    console.log(driver)
  }
}
