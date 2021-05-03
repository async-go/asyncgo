// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from '@rails/ujs'
import '@hotwired/turbo-rails'
import * as ActiveStorage from '@rails/activestorage'
import 'channels'
import 'controllers'

import 'trix'
import '@rails/actiontext'

import '@github/markdown-toolbar-element'
import 'bootstrap'

Rails.start()
ActiveStorage.start()

// Open all external links in a new window
window.addEventListener('click', function (event) {
  const target = event.target
  const el = target.closest('a')
  if (el && !el.isContentEditable && el.host !== window.location.host) {
    el.setAttribute('target', '_blank')
    el.setAttribute('rel', 'noopener noreferrer')
  }
}, true)
