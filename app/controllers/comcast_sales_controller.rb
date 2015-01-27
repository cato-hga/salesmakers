class ComcastSalesController < ApplicationController
  before_action :setup_comcast_customer

  def new
    @comcast_sale = ComcastSale.new
  end

  def create
    @comcast_sale = ComcastSale.new comcast_sale_params
    sale_time = Chronic.parse params.require(:comcast_sale).permit(:sale_date)[:sale_date]
    @comcast_sale.sale_date = sale_time.to_date if sale_time
    @comcast_sale.comcast_customer = @comcast_customer
    @comcast_sale.person = @current_person
    if @comcast_sale.save
      log 'create'
      flash[:notice] = 'Sale saved successfully.'
      redirect_to new_comcast_customer_path and return
    else
      render :new and return
    end
  end

  private

  def setup_comcast_customer
    @comcast_customer = ComcastCustomer.find params[:comcast_customer_id]
  end

  def comcast_sale_params
    params.require(:comcast_sale).permit :order_number,
                                         :tv,
                                         :internet,
                                         :phone,
                                         :security,
                                         :customer_acknowledged
  end

  def log(action)
    @current_person.log? action,
                         @comcast_sale,
                         @current_person
  end

end