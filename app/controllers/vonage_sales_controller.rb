class VonageSalesController < ApplicationController
  before_action :do_authorization, only: [:new, :create, :index, :csv, :show]
  before_action :set_salesmaker, only: [:new, :create]
  before_action :set_vonage_locations, only: [:new, :create]
  before_action :set_vonage_product, only: [:new, :create]
  before_action :chronic_time_zones
  before_action :search_sales, only: [:index, :csv]
  after_action :verify_authorized
  after_action :verify_policy_scoped, only: [:index, :show]

  def index
    @last_import = VonageSale.maximum(:created_at)
    @vonage_sales = @vonage_sales.page(params[:page])
    @areas = policy_scope(@project.areas).order(:name)
  end

  def csv
    respond_to do |format|
      format.html { redirect_to self.send((controller_name + '_path').to_sym) }
      format.csv do
        headers['Content-Disposition'] = "attachment; filename=\"vonage_sales_#{date_time_string}.csv\""
        headers['Content-Type'] ||= 'text/csv'
      end
    end
  end

  def show
    @vonage_sale = policy_scope(VonageSale).find params[:id]
    @walmart_gift_card = WalmartGiftCard.find_by card_number: @vonage_sale.gift_card_number
    @project = Project.find_by name: 'Vonage'
  end

  def new
    @vonage_sale = VonageSale.new
  end

  def create
    @vonage_sale = VonageSale.new vonage_sale_params
    sale_date = params.require(:vonage_sale).permit(:sale_date)[:sale_date]
    chronic_time = Chronic.parse(sale_date)
    adjusted_time = chronic_time.present? ? chronic_time.in_time_zone : nil
    @vonage_sale.sale_date = adjusted_time
    if @vonage_sale.save
      flash[:notice] = 'Vonage Sale has been successfully created.'
      redirect_to new_vonage_sale_path
    else
      render :new
    end
  end

  private

  def set_salesmaker
    @salesmakers = @current_person.managed_team_members.sort_by { |n| n[:display_name] }
    @salesmakers = [@current_person] if @salesmakers.empty?
  end

  def vonage_sale_params
    params.require(:vonage_sale).permit :person_id,
                                        :confirmation_number,
                                        :location_id,
                                        :customer_first_name,
                                        :customer_last_name,
                                        :mac,
                                        :mac_confirmation,
                                        :vonage_product_id,
                                        :gift_card_number,
                                        :gift_card_number_confirmation,
                                        :person_acknowledged,
                                        :creator_id
  end

  def filter_result result
    if params[:areas_includes_id].blank?
      return result
    end
    result.joins(%{
                    left outer join locations l on l.id = vonage_sales.location_id
                    left outer join location_areas la on la.location_id = l.id
                    left outer join areas a on a.id = la.area_id
                    left outer join projects p on p.id = a.project_id
                  }).where(%{
                    p.name = 'Vonage'
                    and la.active = true
                    and '#{params[:areas_includes_id]}' = ANY (string_to_array(cast(a.id as character varying) || '/' || a.ancestry, '/'))
                  })
  end

  def do_authorization
    authorize VonageSale.new
  end

  def search_sales
    @search = policy_scope(VonageSale).
        joins(:person).
        order("sale_date DESC, people.display_name ASC, customer_first_name ASC, customer_last_name ASC").
        search(params[:q])
    @project = Project.find_by name: 'Vonage'
    @vonage_sales = filter_result(@search.result).
        includes(:person, :location)
  end

  def chronic_time_zones
    Chronic.time_class = Time.zone
  end

  def set_vonage_product
    @vonage_products = VonageProduct.all
  end

  def set_vonage_locations
    position_ids = Position.where(all_field_visibility: true).ids
    person_with_all_visibility = Person.where position_id: position_ids
    if person_with_all_visibility.include? @current_person
      vonage = Project.find_by name: 'Vonage'
      return Location.none unless vonage
      @vonage_locations = vonage.
          locations.
          joins("inner join channels on channels.id = locations.channel_id inner join location_areas on location_areas.location_id = locations.id inner join areas on areas.id = location_areas.area_id").
          where("location_areas.active = true and areas.project_id = ?", vonage.id).
          order("channels.name, locations.city, locations.display_name, locations.street_1")
    else
      vonage = Project.find_by name: 'Vonage'
      return Location.none unless vonage
      @vonage_locations = vonage.locations_for_person @current_person
    end
  end

end