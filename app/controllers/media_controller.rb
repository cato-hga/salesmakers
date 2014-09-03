class MediaController < ProtectedController
  def index
    authorize Medium.new
    @media = policy_scope(Medium).all
  end

  def show
  end

  def new
  end

  def edit
  end

  def update
  end

  def create
  end

  def destroy
  end

  def share
  end
end
