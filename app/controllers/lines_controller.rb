class LinesController < ApplicationController
  def index
    @search = Line.search(params[:q])
    @lines = @search.result.order('identifier').page(params[:page])
  end

  def show
    @line = Line.find params[:id]
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
      flash[:notice] = 'Device(s) received successfully'
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

  def swap

  end

  private

  def line_params
    params.require(:line).permit(:identifier, :technology_service_provider_id, :contract_end_date)
  end
end
