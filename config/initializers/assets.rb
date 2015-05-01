Rails.application.config.assets.precompile += %w( masonry.min.js )
Rails.application.config.assets.precompile += %w( jquery-ui-datepicker.js )
Rails.application.config.assets.precompile += %w( google_jsapi.js )
Rails.application.config.assets.precompile += %w( dashboard.js )
Rails.application.config.assets.precompile += %w( foundation_new/foundation.joyride.js )
Rails.application.config.assets.precompile += %w( foundation_new/foundation.cookie.js )

%w(
global_search
candidate_drug_tests
asset_approvals
sprint_sales
docusign_noses
client_access/workmarket_assignments
client_representatives
candidate_availabilities
screenings
sprint_pre_training_welcome_calls
training_availabilities
candidate_contacts
interview_answers
interview_schedules
prescreen_answers
candidates
group_me_groups
changelog_entries
comcast_customers
comcast_sales
comcast_leads
root_redirects
device_manufacturers
device_models
line_states
device_states
poll_questions
feedbacks
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
profiles
projects
questions
reports
sessions
themes
widgets ).each do |controller|
  Rails.application.config.assets.precompile += ["#{controller}.css", "#{controller}.js"]
end