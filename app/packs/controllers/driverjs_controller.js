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

    if (page === 'topics') {
      driver.defineSteps([
        {
          element: '#tourbutton',
          popover: {
            title: 'Topics Page',
            description: 'This is the topics page and it contains all the active discussions happening within your team at a given time. It is designed for working async, so everything is ordered (by default) by the due date, descending. This helps you decide which topics you want to engage with.'
          }
        },
        {
          element: '#activetopics',
          popover: {
            title: 'Active Topics',
            description: 'The active topics list contains everything your team is currently discussing. You can see the title of the topic, the list of active participants, when it is coming due, and when it was created. Topics can be pinned (from within the edit topic page) in order to keep them on the top of the list.'
          }
        },
        {
          element: '#closedtopics',
          popover: {
            title: 'Closed Topics',
            description: 'The closed topics list is similar to the active topics list, but contains items that were already discussed and resolved. They contain a nicely summarized outcome so you can easily see what was decided or done, and read through the comments to see how the team got there.'
          }
        },
        {
          element: '#teammessage',
          popover: {
            title: 'Team Message',
            description: 'You can set a team message from the admin page; this can be useful to share important updates for the team that everyone should see that can impact how or which topics everyone should engage with.'
          }
        },
        {
          element: '#notifications',
          popover: {
            title: 'Notifications',
            description: 'if you have any notifications, they will appear here. you can click on the notification bell to see the list. Other people can notify you by @ mentioning you in a topic, and you will also receive updates for topics you are watching.'
          }
        },
        {
          element: '#activeteam',
          popover: {
            title: 'Active Team',
            description: 'This is the team that you are looking at right now. In the future it will be possible to switch between teams.'
          }
        },
        {
          element: '#admin-nav',
          popover: {
            title: 'Team Admin Page',
            position: 'left-top',
            description: 'This link will take you to the team administration page, where you can set different configuration options for the team including inviting other members, changing billing, contacting support/giving feedback, or setting the team message.'
          }
        },
        {
          element: '#profile-nav',
          popover: {
            title: 'Profile Page',
            position: 'left-top',
            description: 'The personal profile page contains settings related to your own personal preferences. In the future we will be adding per-user profiles, and those will also be updated here.',
          }
        },
        {
          element: '#signout-nav',
          popover: {
            title: 'Sign Out Button',
            position: 'left-top',
            description: 'If you would like to sign out of AsyncGo you can click on this button to do so.',
          }
        },
        {
          element: '#docs-nav',
          popover: {
            title: 'Documentation Link',
            position: 'left-top',
            description: 'Clicking this link will take you to our complete documentation site.',
          }
        },
      ]);
    driver.start();
    }
  }
}
