class Position < ActiveRecord::Base
  validates :name, presence: true, length: { minimum: 5 }
  validates :department, presence: true

  belongs_to :department
  has_many :people
  has_and_belongs_to_many :permissions

  def self.return_from_connect_user(connect_user)
    pos_admin = Position.find_by_name 'System Administrator'
    pos_vrrvp = Position.find_by_name 'Vonage Retail Regional Vice President'
    pos_vrrm = Position.find_by_name 'Vonage Retail Regional Manager'
    pos_vrasm = Position.find_by_name 'Vonage Retail Area Sales Manager'
    pos_vrtm = Position.find_by_name 'Vonage Retail Territory Manager'
    pos_vrss = Position.find_by_name 'Vonage Retail Sales Specialist'

    pos_vervp = Position.find_by_name 'Vonage Event Regional Vice President'
    pos_verm = Position.find_by_name 'Vonage Event Regional Manager'
    pos_veasm = Position.find_by_name 'Vonage Event Area Sales Manager'
    pos_vetl = Position.find_by_name 'Vonage Event Team Leader'
    pos_velit = Position.find_by_name 'Vonage Event Leader in Training'
    pos_vess = Position.find_by_name 'Vonage Event Sales Specialist'

    pos_srrvp = Position.find_by_name 'Sprint Retail Regional Vice President'
    pos_srrm = Position.find_by_name 'Sprint Retail Regional Manager'
    pos_srasm = Position.find_by_name 'Sprint Retail Area Sales Manager'
    pos_srtm = Position.find_by_name 'Sprint Retail Sales Director'
    pos_srss = Position.find_by_name 'Sprint Retail Sales Specialist'

    pos_rsrrvp = Position.find_by_name 'Rosetta Stone Retail Regional Vice President'
    pos_rsrrm = Position.find_by_name 'Rosetta Stone Retail Regional Manager'
    pos_rsrtm = Position.find_by_name 'Rosetta Stone Retail Territory Manager'
    pos_rsrss = Position.find_by_name 'Rosetta Stone Retail Sales Specialist'

    pos_uf = Position.find_by_name 'Unclassified Field Employee'
    pos_uc = Position.find_by_name 'Unclassified HQ Employee'

    pos_td = Position.find_by_name 'Training Director'
    pos_t = Position.find_by_name 'Trainer'

    pos_advd = Position.find_by_name 'Advocate Director'
    pos_advs = Position.find_by_name 'Advocate Supervisor'
    pos_adv = Position.find_by_name 'Advocate'
    pos_rccd = Position.find_by_name 'Recruiting Call Center Director'
    pos_rccr = Position.find_by_name 'Recruiting Call Center Representative'

    pos_ssd = Position.find_by_name 'Senior Software Developer'
    pos_sd = Position.find_by_name 'Software Developer'
    pos_itd = Position.find_by_name 'Information Technology Director'
    pos_itst = Position.find_by_name 'Information Technology Support Technician'

    pos_od = Position.find_by_name 'Operations Director'
    pos_oc = Position.find_by_name 'Operations Coordinator'
    pos_ic = Position.find_by_name 'Inventory Coordinator'
    pos_rc = Position.find_by_name 'Reporting Coordinator'

    pos_fa = Position.find_by_name 'Finance Administrator'
    pos_cont = Position.find_by_name 'Controller'
    pos_acc = Position.find_by_name 'Accountant'

    pos_md = Position.find_by_name 'Marketing Director'

    pos_qad = Position.find_by_name 'Quality Assurance Director'
    pos_qaa = Position.find_by_name 'Quality Assurance Administrator'

    pos_ceo = Position.find_by_name 'Chief Executive Officer'
    pos_coo = Position.find_by_name 'Chief Operations Officer'
    pos_cfo = Position.find_by_name 'Chief Financial Officer'
    pos_vps = Position.find_by_name 'Vice President of Sales'
    pos_ea = Position.find_by_name 'Executive Assistant'

    pos_pd = Position.find_by_name 'Payroll Director'
    pos_pa = Position.find_by_name 'Payroll Administrator'

    pos_hras = Position.find_by_name 'Human Resources Director'
    pos_hra = Position.find_by_name 'Human Resources Administrator'
    connect_user_region = connect_user.region
    area_name = self.clean_area_name connect_user_region
    connect_user_project = (connect_user_region) ? connect_user_region.project : nil

    case connect_user.username
      when 'sdesjarlais@retaildoneright.com'
        position = pos_td
      when 'mgallenstein@retaildoneright.com'
        position = pos_advd
      when 'msiegel@retaildoneright.com'
        position = pos_rccd
      when 'matt@retaildoneright.com'
        position = pos_itd
      when 'rwatier@retaildoneright.com'
        position = pos_ic
      when 'rcushing@retaildoneright.com'
        position = pos_od
      when 'emontesdeoca@retaildoneright.com'
        position = pos_fa
      when 'bzopolsky@retaildoneright.com'
        position = pos_cont
      when 'cwilcox@retaildoneright.com'
        position = pos_acc
      when 'sriker@retaildoneright.com'
        position = pos_md
      when 'nissaev@retaildoneright.com'
        position = pos_rc
      when 'jcarmichael@retaildoneright.com'
        position = pos_qaa
      when 'charris@retaildoneright.com'
        position = pos_qad
      when 'jimmy@retaildoneright.com'
        position = pos_ceo
      when 'kevin@retaildoneright.com'
        position = pos_coo
      when 'cdipasquale@retaildoneright.com'
        position = pos_cfo
      when 'dharty@retaildoneright.com'
        position = pos_vps
      when 'mtotan@retaildoneright.com'
        position = pos_pd
      when 'mcarmona@retaildoneright.com'
        position = pos_pa
      when 'lrozar@retaildoneright.com'
        position = pos_pa
      when 'adaly@retaildoneright.com'
        position = pos_pa
      when 'jcullen@retaildoneright.com'
        position = pos_hras
      when 'msrinivasa@retaildoneright.com'
        position = pos_itst
      when 'zmathew@retaildoneright.com'
        position = pos_itst
      when 'sgoudard@retaildoneright.com'
        position = pos_itst
      when 'dkorb@retaildoneright.com'
        position = pos_itst
      when 'joneal@retaildoneright.com'
        position = pos_oc
      when 'nhissa@retaildoneright.com'
        position = pos_oc
      when 'mhafer@retaildoneright.com'
        position = pos_ea
      when 'dshort@retaildoneright.com'
        position = pos_ea
      when 'jhade@retaildoneright.com'
        position = pos_srrm
      when 'rpitman@retaildoneright.com'
        position = pos_srrm
      when 'tkarlin@retaildoneright.com'
        position = pos_srrm
      when 'bcarter@retaildoneright.com'
        position = pos_srrvp
      when 'dginn@retaildoneright.com'
        position = pos_rsrrvp
    end

    return position if position

    if not area_name and not connect_user_project and not connect_user.username.include? '@retaildoneright.com'
      return pos_uf
    elsif (connect_user_project == 'Corporate' or not connect_user_project) and connect_user.username.include? '@retaildoneright.com'
      return pos_uc
      # TODO: Go back and change LIT's to non-HQ
    end

    if connect_user_region.name.include? 'Retail' or connect_user_region.name.include? 'Sprint'
      retail = true
    end
    event = connect_user_region.name.include? 'Event'
    retail = true if not retail and not event

    return nil if not connect_user_project
    project_name = connect_user_project.name
    vonage = project_name == 'Vonage'
    sprint = project_name == 'Sprint'
    rs = project_name == 'Rosetta Stone'
    corporate = project_name == 'Corporate'
    
    recruit = area_name.downcase.include? 'recruit'
    advocate = area_name.downcase.include? 'advocate'
    hr = area_name.downcase.include? 'human'
    training = area_name.downcase.include? 'training'
    technology = area_name.downcase.include? 'technology'
    operations = area_name.downcase.include? 'operations'
    accounting = area_name.downcase.include? 'accounting'
    leader = connect_user.leader?
    
    position = nil
    case connect_user_region.fast_type
      when 4
        if leader
          position = pos_vrtm if vonage and retail
          position = pos_vetl if vonage and event
          position = pos_srtm if sprint and retail
          position = pos_rsrtm if rs and retail
          position = pos_hras if corporate and recruit
          position = pos_advs if corporate and advocate
          position = pos_hrd if corporate and hr
          position = pos_td if corporate and training
          position = pos_itd if corporate and technology
        else
          position = pos_vrss if vonage and retail
          position = pos_vess if vonage and event
          position = pos_srss if sprint and retail
          position = pos_rsrss if rs and retail
          position = pos_hra if corporate and recruit
          position = pos_adv if corporate and advocate
          position = pos_hra if corporate and hr
          position = pos_t if corporate and training
          position = pos_itst if corporate and technology
          position = pos_oc if corporate and operations
          position = pos_acc if corporate and accounting
        end
      when 3
        if leader
          position = pos_vrasm if vonage and retail
          position = pos_veasm if vonage and event
          position = pos_advd if corporate and recruit
        end
      when 2
        if leader
          position = pos_vrrm if vonage and retail
          position = pos_verm if vonage and event
          position = pos_srrm if sprint and retail
          position = pos_rsrrm if rs and retail
        end
      when 1
        if leader
          position = pos_vrrvp if vonage and retail
          position = pos_vervp if vonage and event
          position = pos_srrvp if sprint and event
          position = pos_rsrrvp if rs and event
        end
    end

    if sprint and connect_user.username.include? '@retaildoneright.com'
      position = pos_srtm
    end

    position = pos_uf unless position
    position
  end

  def self.clean_area_name(connect_region)
    return nil unless connect_region and connect_region.name
    area_name = connect_region.name

    area_name = area_name.gsub('Vonage Retail - ', '')
    area_name = area_name.gsub('Rosetta Stone - ', '')
    area_name = area_name.gsub('Vonage Events - ', '')
    area_name = area_name.gsub('Sprint - ', '')
    area_name.gsub('Retail Team', 'Kiosk')
  end

end
