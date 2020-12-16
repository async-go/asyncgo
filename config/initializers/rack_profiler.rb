# frozen_string_literal: true

if Rails.env.development?
  require 'rack-mini-profiler'

  # Move profiler to right to not overlap logo
  Rack::MiniProfiler.config.position = 'right'

  # Initialization is skipped so trigger it
  Rack::MiniProfilerRails.initialize!(Rails.application)
end
