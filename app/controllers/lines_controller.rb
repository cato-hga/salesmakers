class LinesController < ApplicationController
  before_action :set_line_and_line_state, only: [:remove_state, :add_state]
  
  def index
    @search = Line.search(params[:q])
    @lines = @search.result.order('identifier').page(params[:page])
  end

  def show
    @line = Line.find params[:id]
    @unlocked_line_states = LineState.where locked: false
  end

  def create
    string_contract_date = line_params[:contract_end_date]
    date_contract_date = Chronic.parse(string_contract_date)
    @line = Line.new line_params
    @line.contract_end_date = date_contract_date
    @creator = @current_person
    active_state = LineState.find_by name: 'Active'
    @line.line_states << active_state
    if @line.save
      @creator.log? 'create', @line
      flash[:notice] = 'Line(s) received successfully'
      redirect_to lines_path
    else
      puts @line.errors.full_messages.join(', ')
      flash[:error] = 'Line(s) not saved!'
      redirect_to new_line_path
    end
  end

  def new
    @line = Line.new
  end

  def destroy
  end

  def edit
  end

  def update
  end

  def remove_state
    if @line and @line_state
      deleted = @line.line_states.delete @line_state
      if deleted
        flash[:notice] = 'State removed from line'
        redirect_to line_path(@line)
      end
    else
      flash[:error] = 'Could not find that line or line state'
      redirect_to line_path(@line)
    end
  end

  def add_state
    if @line and @line_state
      @line.line_states << @line_state
      @line.reload
      if @line.line_states.include?(@line_state)
        flash[:notice] = 'State added to line'
        redirect_to line_path(@line)
      else
        flash[:error] = 'State could not be added to line'
        redirect_to line_path(@line)
      end
    else
      flash[:error] = 'Could not find that line or line state'
      redirect_to line_path(@line)
    end
  end

  private
  
  def set_line_and_line_state
    @line = Line.find state_params[:id]
    if state_params[:line_state_id].blank?
      flash[:error] = 'You did not select a state to add'
      redirect_to line_path(@line) and return
    end
    @line_state = LineState.find state_params[:line_state_id]
    if @line_state.locked?
      flash[:error] = 'You cannot add or remove built-in line states'
      redirect_to line_path(@line) and return
    end
  end
  
  def line_params
    params.require(:line).permit(:identifier, :technology_service_provider_id, :contract_end_date)
  end

  def state_params
    params.permit :id, :line_state_id
  end
  
end
