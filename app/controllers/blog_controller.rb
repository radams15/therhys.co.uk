class BlogController < ApplicationController
  @@blog_model = BlogModel.new;

  def new

  end

  def posts
    @posts = @@blog_model.posts

    p @posts
  end
end
