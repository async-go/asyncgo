import Tribute from 'tributejs'
const tribute = new Tribute({
  values: [
    { key: 'Phil Hartman', value: 'Phil_Hartman' },
    { key: 'الصادق الرضي', value: 'الصادق_الرضي' },
    { key: 'Григорий Ефимович Распутин', value: 'Григорий_Ефимович_Распутин' },
    { key: 'Me\'Shell Ndegéocello', value: 'Me\'Shell_Ndegéocello'},
    { key: 'Gordon Ramsey', value: 'Gordon_Ramsey' }
  ]
})

tribute.attach(document.querySelectorAll('.mentionable'))
