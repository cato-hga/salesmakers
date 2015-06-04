class SMSDailyChecksController < ApplicationController

  after_action :verify_authorized

  def index
    authorize SMSDailyCheck.new
    postpaid = Project.find_by name: 'Sprint Postpaid'
    @available_teams = Area.where(project: postpaid)
    @times = [
        { name: '7am', time: 7 },
        { name: '8am', time: 8 },
        { name: '9am', time: 9 },
        { name: '10am', time: 10 },
        { name: '11am', time: 11 },
        { name: 'Noon', time: 12 },
        { name: '1pm', time: 13 },
        { name: '2pm', time: 14 },
        { name: '3pm', time: 15 },
        { name: '4pm', time: 16 },
        { name: '5pm', time: 17 },
        { name: '6pm', time: 18 },
        { name: '7pm', time: 19 },
        { name: '8pm', time: 20 },
        { name: '9pm', time: 21 },
        { name: '10pm', time: 22 },
        { name: '11pm', time: 23 }
    ]
    if params[:select_team]
      @team = params[:select_team]
      person_areas = PersonArea.where(area: @team).joins(:person).order('people.display_name')
      @people = []
      for area in person_areas do
        @people << area.person if area.person.active
      end
      @people
    end
  end

  def update

  end
end
