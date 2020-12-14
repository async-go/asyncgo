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
    @topic = current_user.topics.build(topic_params)

    if @topic.save
      redirect_to topic_path(@topic),
                  flash: { success: 'Topic was successfully created.' }
    else
      render :new
    end
  end

  private

  def topic_params
    params.require(:topic).permit(:title)
  end
end
