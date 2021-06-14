# frozen_string_literal: true

class TopicsFinder
  def initialize(team, includes, params)
    @team = team
    @includes = includes
    @params = params
  end

  def call
    @team.topics.includes(*@includes).where(status: @params[:status]).order(pinned: :desc, finder_sort => finder_order)
  end

  private

  def finder_sort
    @params[:sort] || 'due_date'
  end

  def finder_order
    case @params[:status]
    when 'active'
      parameter_order
    when 'resolved'
      inverse_order(parameter_order)
    end
  end

  def parameter_order
    @params[:order] || :asc
  end

  def inverse_order(order)
    case order
    when :desc
      :asc
    else
      :desc
    end
  end
end
