document.addEventListener('turbolinks:load', function () {
  document.querySelectorAll('.text-area-autoresize').forEach(function (element) {
    element.style.height = element.scrollHeight + 'px'
    element.addEventListener('input', function (event) {
      if (parseInt(event.target.style.height, 10) <= event.target.scrollHeight) {
        event.target.style.height = event.target.scrollHeight + 'px'
      }
    })
  })
})
