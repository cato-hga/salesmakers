class LineStatesController < ApplicationController

  def index
    @line_states = LineState.all
  end

  def new
    @line_state = LineState.new
  end

  def create
    @line_state = LineState.new line_state_params
    if @line_state.save
      flash[:notice] = 'Line State successfully created'
      redirect_to line_states_path
    else
      render :new
    end
  end

  private

  def line_state_params
    params.require(:line_state).permit :name
  end

end