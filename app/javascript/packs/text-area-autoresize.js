import autosize from 'autosize'

document.addEventListener('turbolinks:load', function () {
  document.querySelectorAll('.text-area-autoresize').forEach(function (element) {
    autosize(element)
  })
})
