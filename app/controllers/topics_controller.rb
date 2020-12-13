# frozen_string_literal: true

class TopicsController < ApplicationController
  def index
    @topics = Topic.all
  end

  def show
    @topic = Topic.find(params[:id])
  end

  def new
    @topic = Topic.new
  end

  def create
    @topic = Topic.new(topic_params.merge(user: User.first))

    @topic.save

    redirect_to topic_path(@topic)
  end

  private

  def topic_params
    params.require(:topic).permit(:title)
  end
end
