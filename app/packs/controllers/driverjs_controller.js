import { Controller } from 'stimulus'
import Driver from 'driver.js'

export default class extends Controller {
  connect () {
    console.log('Hello connect')
  }

  demo (event) {
    event.stopImmediatePropagation()
    const driver = new Driver()

    const path = window.location.pathname
    const page = path.split('/').pop()
    console.log(page)

    if (page === 'topics') {
      driver.defineSteps([
        popover: {
      driver.highlight({
        element: '#notifications',
        popover: {
          title: 'Notifications',
          description:
                        'This box shows you any notifications you might have. You can click on it to see them.'
        }
      })
    }
  }
}
