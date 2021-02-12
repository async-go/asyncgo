document.addEventListener('turbolinks:load', function () {
  document.querySelectorAll('.text-area-autoresize').forEach(function (element) {
    element.style.height = element.scrollHeight + 'px'
    element.addEventListener('input', function (event) {
      const previousHeight = event.target.style.height
      event.target.style.height = 'auto'
      if (event.target.scrollHeight < 320) {
        event.target.style.height = event.target.scrollHeight + 'px'
      } else {
        event.target.style.height = previousHeight
      }
    })
  })
})
