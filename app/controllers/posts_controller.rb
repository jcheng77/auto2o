class PostsController < InheritedResources::Base

  before_action :set_post , except: [:index, :create, :new]

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)

    respond_to do |format|
      if @post.save
        format.html {redirect_to posts_path }
        format.json
      else
        format.html
        format.json
      end
    end

  end

  def edit
  end

  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html {redirect_to @post, notice: 'Post is successfully updated'}
        format.json
      else
        format.html
        format.json
      end
    end

  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title,:url,:pic_url,:description)
  end

end
