document.addEventListener('turbolinks:load', function () {
  document.querySelectorAll('.text-area-autoresize').forEach(function (element) {
    if (element.scrollHeight < (window.innerHeight * .6)) {
      element.style.height = 'auto'
      element.style.height = element.scrollHeight + 'px'
    } else {
      element.style.height = 'auto'
      element.style.height = (window.innerHeight * .6) + 'px'
    }
    element.addEventListener('input', function (event) {
      console.log(event.target.scrollHeight)
      if (event.target.scrollHeight < (window.innerHeight * .6)) {
        event.target.style.height = 'auto'
        event.target.style.height = event.target.scrollHeight + 'px'
      } else {
        event.target.style.height = 'auto'
        event.target.style.height = (window.innerHeight * .6) + 'px'
      }
    })
  })
})
