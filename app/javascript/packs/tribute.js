import Tribute from 'tributejs'
const tribute = new Tribute({
  values: [
    { key: 'Phil Heartman', value: 'Phil_Heartman' },
    { key: 'Gordon Ramsey', value: 'Gordon_Ramsey' }
  ]
})

tribute.attach(document.querySelectorAll('.mentionable'))
