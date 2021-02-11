document.addEventListener('turbolinks:load', function () {
  document.querySelectorAll('.text-area-autoresize').forEach(function (element) {
    element.style.height = element.scrollHeight + 'px'
    element.addEventListener('input', function (event) {
      event.target.style.height = 'auto'
      event.target.style.height = event.target.scrollHeight + 'px'
    })
  })
})
