class SimpleSource
  def initialize model_class
    @objects = model_class.all.order(:created_at)
  end

  def each
    @objects.each do |o|
      att = o.attributes
      att.delete('id')
      att.delete('created_at')
      att.delete('updated_at')
      yield att
    end
  end
end