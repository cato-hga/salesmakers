module DevicesAndLines
  module StateHandler
    def set_object_and_state(type)
      self.instance_variable_set "@#{type}".to_sym,
                                 Object.const_get(type.capitalize).
                                     find(state_params[:id])
      @object = self.instance_variable_get "@#{type}".to_sym
      if state_params["#{type}_state_id".to_sym].blank?
        flash[:error] = 'You did not select a state to add'
        redirect_to self.send("#{type}_path".to_sym,
                              self.instance_variable_get("@#{type}".to_sym)) and return
      end
      self.instance_variable_set "@#{type}_state".to_sym,
                                 Object.const_get("#{type.capitalize}State").
                                     find(state_params["#{type}_state_id".to_sym])
      @object_state = self.instance_variable_get "@#{type}_state".to_sym
      if self.instance_variable_get("@#{type}_state".to_sym).locked?
        flash[:error] = "You cannot add or remove built-in #{type} states"
        redirect_to self.send("#{type}_path".to_sym,
                              self.instance_variable_get("@#{type}".to_sym)) and return
      end
    end

    def remove_object_state
      if @object and @object_state
        type = @object.model_name.name.downcase
        deleted = @object.send("#{type}_states").delete @object_state
        if deleted
          @current_person.log? 'remove_state',
                               @object,
                               @object_state
          flash[:notice] = "State removed from #{type}"
          redirect_to self.send("#{type}_path".to_sym, @object)
        end
      else
        flash[:error] = "Could not find that #{type} or #{type} state"
        redirect_to self.send("#{type}_path".to_sym, @object)
      end
    end
  end
end