class LineStatesController < ApplicationController
  before_action :check_locked_status, only: [:edit, :update]

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

  def edit
  end

  def update
    if @line_state.update line_state_params
      flash[:notice] = 'Line State successfully updated'
      redirect_to line_states_path
    else
      render :edit
    end
  end

  private

  def line_state_params
    params.require(:line_state).permit :name
  end

  def check_locked_status
    @line_state = LineState.find params[:id]
    if @line_state.locked
      flash[:error] = 'That Line State is locked and cannot be edited.'
      redirect_to line_states_path
    end
  end

end