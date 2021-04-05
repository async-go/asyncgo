import { Controller } from 'stimulus'
import Driver from 'driver.js'

export default class extends Controller {
  demo (event) {
    event.stopImmediatePropagation()
    const driver = new Driver()

    const path = window.location.pathname
    const page = path.split('/').pop()
    const context = path.split('/')[1]

    // These steps are always included, if available
    const baseSteps = [
      {
        element: '#notifications',
        popover: {
          title: 'Notifications',
          description: 'If you have any notifications they will appear here; you can click on the notification bell to see the list. Other people can notify you by @ mentioning you in a topic, and you will also receive updates for topics you are watching.'
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
        element: '#createteam-nav',
        popover: {
          title: 'Create Team Page',
          position: 'left-top',
          description: 'The first step to do if you are a new user of AsyncGo is to create a team. Once you have done so, the rest of the app will open up. If you are expecting to be a member of a team already because you were invited, then check with the owner of the team.'
        }
      },
      {
        element: '#topics-nav',
        popover: {
          title: 'Topics Page',
          position: 'left-top',
          description: 'The topics list contains all the active topics that your team is discussing, as well as any important team-level messages, and the list of closed topics. Clicking on this link will take you there.'
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
          description: 'The personal profile page contains settings related to your own personal preferences. In the future we will be adding per-user profiles, and those will also be updated here.'
        }
      },
      {
        element: '#signin-nav',
        popover: {
          title: 'Sign In Button',
          position: 'left-top',
          description: 'Click here to sign in to AsyncGo. We provide several options for you to choose from to authenticate. You can also click directly on the sign in buttons for each provider in the middle of this page.'
        }
      },
      {
        element: '#signout-nav',
        popover: {
          title: 'Sign Out Button',
          position: 'left-top',
          description: 'If you would like to sign out of AsyncGo you can click on this button to do so.'
        }
      },
      {
        element: '#docs-nav',
        popover: {
          title: 'Documentation Link',
          position: 'left-top',
          description: 'Clicking this link will take you to our complete documentation site.'
        }
      }]

    // These steps are used when making a new or updating a topic
    const topicSteps = [
      {
        element: '#topic-title',
        popover: {
          title: 'Title',
          description: 'Setting a title for your topic is very important. Use a clear, descriptive name that makes it easy to undertand what you want to discuss.'
        }
      },
      {
        element: '#topic-participants',
        popover: {
          title: 'Participants',
          description: 'The list of people participating in the topic can be found here. As with the list on the topic index, the creator of the topic is always listed first.'
        }
      },
      {
        element: '#topic-description',
        popover: {
          title: 'Description',
          description: 'The description serves as the context for the discussion. You should include any references to other materials that are important, and make it clear what phases/steps you expect to happen as part of the discussion. You can think of it as the discussion agenda.'
        }
      },
      {
        element: '#topic-templates',
        popover: {
          title: 'Templates',
          description: 'We provide some templates that you can use if you are unsure how to structure your topic.'
        }
      },
      {
        element: '#topic-outcome',
        popover: {
          title: 'Outcome',
          description: 'The outcome is not just for use when editing the topic, but you can also use it at the very begining to structure what you think the outcome should be. For example, you may already include a section on action items and leave it blank to make it clear that you expect action items to be one of the outcomes.'
        }
      },
      {
        element: '#topic-labellist',
        popover: {
          title: 'Label List',
          description: 'You can set labels for topics here. Labels make it easier to find and filter topics from the index. They can also be used to indicate priority, projects, or any other metadata that is important to see at a glance and filter on.'
        }
      },
      {
        element: '#topic-duedate',
        popover: {
          title: 'Due Date',
          description: 'Setting a due date is very important when working async. It lets everyone know when they need to contribute by, if they want to take part in the topic.'
        }
      }
    ]

    // Home page
    if (page === '') {
      driver.defineSteps([
        {
          element: '#tourbutton',
          popover: {
            title: 'Welcome to AsyncGo!',
            description: 'Thanks for visiting AsyncGo! Most pages have this tour button in the top left, which will take you through the contents of the page and help you get started.'
          }
        }
      ].concat(baseSteps))
      driver.start()
    }

    // Team Admin
    if (page === 'edit' && context === 'teams') {
      driver.defineSteps([
        {
          element: '#tourbutton',
          popover: {
            title: 'Team Admin',
            description: 'The team admin page lets you change various settings about how your team works, and what information is shown/available to team members.'
          }
        },
        {
          element: '#teamname',
          popover: {
            title: 'Team Name',
            description: 'You can always change your team name from here.'
          }
        },
        {
          element: '#teammessage',
          popover: {
            title: 'Team Message',
            description: 'The team message is a great way to get the word out about important priorities or other updates on your team. Whatever message you set here will be visible from the topic list.'
          }
        },
        {
          element: '#inviteusers',
          popover: {
            title: 'Invite Users',
            description: 'To add users to your team enter their email address here. Note that the email address they use will need to be associated with a valid authorization method (for example, they need to be able to log in using Google with that email address).'
          }
        },
        {
          element: '#usersinteam',
          popover: {
            title: 'User List',
            description: 'This section contains the list of users in your team. You can remove anyone by clicking on their name.'
          }
        },
        {
          element: '#billing',
          popover: {
            title: 'Billing Info',
            description: 'You can check your current billing status in this area.'
          }
        },
        {
          element: '#supportform',
          popover: {
            title: 'Support Form',
            description: 'You can always use the support form to let us know about issues, but we also encourage you to use it to share feedback on anything you would like to see in the product. We would love to hear from you!'
          }
        }
      ].concat(baseSteps))
      driver.start()
    }

    // User Profile
    if (page === 'edit' && context === 'users') {
      driver.defineSteps([
        {
          element: '#tourbutton',
          popover: {
            title: 'User Profile',
            description: 'The user profile page is where your personal settings are. In the future this will include a personal profile that you can share with others.'
          }
        },
        {
          element: '#digests',
          popover: {
            title: 'Digest Emails',
            description: 'If you like, AsyncGo will email you once per day with all the todos that you have in your list. This can be a good way to make sure you get at least one notification of what is going on per day.'
          }
        },
        {
          element: '#layout',
          popover: {
            title: 'Page Layout',
            description: 'You can choose between the default layout or one that uses more of the screen.'
          }
        },
        {
          element: '#about',
          popover: {
            title: 'About Asyncgo',
            description: 'Important information about the terms and conditions of your use of AsyncGo can be found here.'
          }
        }
      ].concat(baseSteps))
      driver.start()
    }

    // New topic
    if (page === 'new' && context === 'teams') {
      driver.defineSteps([
        {
          element: '#tourbutton',
          popover: {
            title: 'New Topic',
            description: 'Creating a new topic is an important step in starting a discussion. You can use the structure here to think through how you want the conversation to go and what kinds of results you expect. The more clear you can make your topic, the better results you will get.'
          }
        }
      ].concat(topicSteps).concat(baseSteps))
      driver.start()
    }

    // Editing a Topic
    if (page > 0 && context === 'teams') {
      driver.defineSteps([
        {
          element: '#tourbutton',
          popover: {
            title: 'Participating in Topics',
            description: 'Topics are at the heart of AsyncGo. Whether creating, editing, or commenting, this is where the action happens and how you get to good async results. Topics themselves can have emojis applied to them from this page.'
          }
        }].concat(topicSteps).concat([
        {
          element: '#topic-edit',
          popover: {
            title: 'Edit Button',
            description: 'The edit button will put you in edit mode, allowing you to change the title, description, outcome, due date, and other values.'
          }
        },
        {
          element: '#topic-watch',
          popover: {
            title: 'Watch Button',
            description: 'Watching a topic will mark you as a participant and you will also receive notifications about it.'
          }
        },
        {
          element: '#topic-pin',
          popover: {
            title: 'Pinning Topics',
            description: 'By pinning a topic you can keep at always at the top of the relevant list on the topic index page.'
          }
        },
        {
          element: '#topic-resolve',
          popover: {
            title: 'Resolving Topics',
            description: 'By resolving a topic you lock in the current state, preventing future edits (unless reopened). It will also move from the active topic list to the resolved topic list.'
          }
        },
        {
          element: '#topic-comments',
          popover: {
            title: 'Commenting on Topics',
            description: 'Commenting on topics is how you can be heard. Everyones comments can have emojis applied to help gather feedback, or as a form of voting.'
          }
        }
      ]).concat(baseSteps))
      driver.start()
    }

    // Topics Index
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
          element: '#teammessage',
          popover: {
            title: 'Team Message',
            description: 'You can set a team message from the admin page; this can be useful to share important updates for the team that everyone should see that can impact how or which topics everyone should engage with.'
          }
        },
        {
          element: '#closedtopics',
          popover: {
            title: 'Closed Topics',
            description: 'The closed topics list is similar to the active topics list, but contains items that were already discussed and resolved. They contain a nicely summarized outcome so you can easily see what was decided or done, and read through the comments to see how the team got there.'
          }
        }
      ].concat(baseSteps))
      driver.start()
    }
  }
}
