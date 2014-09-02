class BlogPostsController < ProtectedController
  layout false, only: :show

  def index
    authorize BlogPost.new
    @blog_posts = policy_scope(BlogPost).all
  end

  def new
  end

  def create
  end

  def show
    @blog_post = BlogPost.find params[:id]
    authorize @blog_post
  end

  def edit
  end

  def update
  end

  def destroy
  end

  def publish
  end

  def approve
  end

  def deny
  end
end
