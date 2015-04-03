module AvailabilityParams


  protected

  def availability_params
    params.require(:candidate_availability).permit(
        :monday_first,
        :monday_second,
        :monday_third,
        :tuesday_first,
        :tuesday_second,
        :tuesday_third,
        :wednesday_first,
        :wednesday_second,
        :wednesday_third,
        :thursday_first,
        :thursday_second,
        :thursday_third,
        :friday_first,
        :friday_second,
        :friday_third,
        :saturday_first,
        :saturday_second,
        :saturday_third,
        :sunday_first,
        :sunday_second,
        :sunday_third,
        :comment
    )
  end

end