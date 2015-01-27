# class BlogPostsController < ProtectedController
#   layout false, only: :show
#
#   def index
#     authorize BlogPost.new
#     @blog_posts = policy_scope(BlogPost).all
#   end
#
#   def show
#     @blog_post = BlogPost.find params[:id]
#     authorize @blog_post
#   end
# end
