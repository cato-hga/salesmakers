class WallPost < ActiveRecord::Base

  belongs_to :wall
  belongs_to :person
  belongs_to :publication
  belongs_to :reposted_by_person, class_name: 'Person'
  has_many :likes
  has_many :wall_post_comments, dependent: :destroy

  after_save :broadcast

  default_scope { order updated_at: :desc}

  def self.create_from_publication(publication, wall)
    return unless able_to_publish?
    self.find_or_create_by publication: publication,
                           wall: wall,
                           person: publication.person
  end

  def self.visible(person, walls = nil, include_own = true)
    or_condition = 'false'
    or_condition = 'person_id = ' + person.id.to_s if include_own
    if walls
      walls_condition = "wall_id IN (#{walls.map(&:id).join(',')})"
      self.where(walls_condition + ' OR ' + or_condition).
          includes(:person,
                   wall: :wallable,
                   publication: :publishable,
                   wall_post_comments: :person)
    else
      walls = Wall.visible(person)
      walls_condition = "wall_id IN (#{walls.map(&:id).join(',')})"
      posts = self.where(walls_condition + ' OR ' + or_condition).
          includes(:person,
                   wall: :wallable,
                   publication: :publishable,
                   wall_post_comments: :person)
    end
  end

  def self.just_logged_in_post(person)
    return unless person and person.wall and person.department
    department = person.department
    text_post = TextPost.new content: 'I just logged in for the first time!',
                             person: person
    if text_post.save
      return unless text_post.publication
      publication = text_post.publication
      WallPost.find_or_create_by publication: publication,
                                 wall: department.wall,
                                 person: person
    end
  end

  def self.send_welcome_post(person)
    return unless person and person.wall
    sys_admin = Person.find_by email: 'retailingw@retaildoneright.com'
    text_post = TextPost.new content: 'Welcome ' + person.social_name + '! ' +
        'Edit your profile, check out your co-workers\' profiles, and start ' +
        'sharing!',
                             person: sys_admin
    if text_post.save
      return unless text_post.publication
      publication = text_post.publication
      WallPost.find_or_create_by publication: publication,
                                 wall: person.wall,
                                 person: sys_admin
    end
  end

  private

  def broadcast
    return unless self.id_changed? or self.wall_id_changed?
    WebsocketRails['wall_' + self.wall_id.to_s].trigger :new, self
  end

  def able_to_publish?
    publication and
        publication.person and
        wall
  end

end
