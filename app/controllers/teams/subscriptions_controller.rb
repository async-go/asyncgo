# frozen_string_literal: true

require './lib/fast_spring'

module Teams
  class SubscriptionsController < Teams::ApplicationController
    def edit
      redirect_to ::FastSpring.generate_account_management_link(current_user.email)
    end

    def webhook
      successful_events = []

      webhook_events.each do |webhook_event|
        successful_events << process_webhook_event(webhook_event)
      end

      render status: :accepted, plain: successful_events.compact.join('\n')
    end

    private

    def webhook_events
      params.require(:events)
    end

    def process_webhook_event(webhook_event)
      case webhook_event['type']
      when 'subscription.activated'
        activate_subscription(webhook_event['tags']['brandId'])
        webhook_event['id']
      when 'subscription.deactivated'
        deactivate_subscription(webhook_event['tags']['brandId'])
        webhook_event['id']
      end
    end

    def activate_subscription(brand_id)
      Subscription.find_or_initialize_by(brand_id: brand_id).update!(active: true)
    end

    def deactivate_subscription(brand_id)
      Subscription.find_by(brand_id: brand_id).update!(active: false)
    end
  end
end
