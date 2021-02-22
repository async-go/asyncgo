import Tribute from 'tributejs'

const host = window.location.protocol + '//' + window.location.host
window.fetch(`${host}/teams/${window.gon.teamId}/users.json`)
  .then(response => response.json())
  .then(function (data) {
    const tribute = new Tribute({
      values: data
    })

    tribute.attach(document.querySelectorAll('.mentionable'))
  })
