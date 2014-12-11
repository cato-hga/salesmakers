class LineStatesController < ApplicationController

  def index
    @line_states = LineState.all
  end

end