import { Controller } from 'stimulus'

export default class extends Controller {
  demo () {
    const fscSession = {
      reset: true,
      products: [
        {
          path: 'asyncgo-team',
          quantity: 1
        }
      ],
      tags: { brandId: `${window.gon.teamId}` }
    }
    fastspring.builder.push(fscSession)
    fastspring.builder.checkout()
  }
}
