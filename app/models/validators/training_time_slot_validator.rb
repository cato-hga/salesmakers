class TrainingTimeSlotValidator < ActiveModel::Validator
  def validate(record)
    unless record.monday == true or
        record.tuesday == true or
        record.wednesday == true or
        record.thursday == true or
        record.friday == true or
        record.saturday == true or
        record.sunday == true
      record.errors[:day_of_the_week] << "must be selected'"
      return
    end
  end
end
