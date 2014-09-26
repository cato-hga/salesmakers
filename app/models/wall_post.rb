class WallPost < ActiveRecord::Base

  belongs_to :wall
  belongs_to :person
  belongs_to :publication
  belongs_to :reposted_by_person, class_name: 'Person'
  has_many :likes
  has_many :wall_post_comments, dependent: :destroy

  default_scope { order updated_at: :desc}

  def self.create_from_publication(publication, wall)
    return unless publication and publication.publishable.person and publication.publishable.person and wall
    self.find_or_create_by publication: publication,
                           wall: wall,
                           person: publication.publishable.person
  end

  def self.visible(person, walls = nil)
    if walls
      self.where(wall: walls).includes(:person, wall: :wallable, publication: :publishable, wall_post_comments: :person)
    else
      self.where(wall: Wall.visible(person)).includes(:person, wall: :wallable, publication: :publishable, wall_post_comments: :person)
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
end
