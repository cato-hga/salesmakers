class ThemesController < ApplicationController
  def index
    @themes = Theme.all
  end

  def new
    @theme = Theme.new
  end

  def create
    @theme = Theme.new theme_params
    if @theme.save
      flash[:notice] = 'Theme created.'
      redirect_to themes_path
    else
      render :new
    end
  end

  def edit
    @theme = Theme.find params[:id]
  end

  def update
    @theme = Theme.find params[:id]
    if @theme.update_attributes theme_params
      flash[:notice] = 'Theme saved.'
      redirect_to themes_path
    else
      render :edit
    end
  end

  private

  def theme_params
    params.require(:theme).permit(:display_name, :name)
  end
end
