Rails.application.config.assets.precompile += %w( masonry.min.js )
Rails.application.config.assets.precompile += %w( jquery-ui-datepicker.js )
Rails.application.config.assets.precompile += %w( google_jsapi.js )
Rails.application.config.assets.precompile += %w( dashboard.js )
Rails.application.config.assets.precompile += %w( foundation_new/foundation.joyride.js )
Rails.application.config.assets.precompile += %w( foundation_new/foundation.cookie.js )

%w(
asset_approvals
candidate_availabilities
candidate_contacts
candidate_drug_tests
candidates
changelog_entries
client_access/workmarket_assignments
client_representatives
comcast_customers
comcast_leads
comcast_sales
device_manufacturers
device_models
device_states
docusign_noses
feedbacks
global_search
group_me_groups
interview_answers
interview_schedules
line_states
poll_questions
prescreen_answers
root_redirects
screenings
sprint_pre_training_welcome_calls
sprint_sales
training_availabilities
wall_post_comments
likes
wall_posts
profile_experiences
profile_educations
profile_skills
text_posts
uploaded_images
uploaded_videos
group_mes
area_types
areas
blog_posts
channels
clients
departments
device_deployments
devices
gallery
home
lines
log_entries
media
people
permission_groups
positions
locations
profiles
projects
questions
reports
sessions
themes
widgets ).each do |controller|
  Rails.application.config.assets.precompile += ["#{controller}.css", "#{controller}.js"]
end