/* global fastspring */

import { Controller } from 'stimulus'

export default class extends Controller {
  buy () {
    const fscSession = {
      reset: true,
      products: [
        {
          path: 'asyncgo-team',
          quantity: 1
        }
      ],
      tags: { teamId: `${window.gon.teamId}` }
    }
    fastspring.builder.push(fscSession)
    fastspring.builder.checkout()
  }
}
