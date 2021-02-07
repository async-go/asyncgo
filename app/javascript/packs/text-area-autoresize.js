document.querySelectorAll('.text-area-autoresize').forEach(function (element) {
  element.style.boxSizing = 'border-box'
  const offset = element.offsetHeight - element.clientHeight
  element.style.height = element.scrollHeight + offset + 'px'
  element.addEventListener('input', function (event) {
    event.target.style.height = 'auto'
    event.target.style.height = event.target.scrollHeight + offset + 'px'
  })
  element.removeAttribute('text-area-autoresize')
  element.dispatchEvent(new Event('input'))
})