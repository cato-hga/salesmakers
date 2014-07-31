seeds = "#{Rails.root}/db/seeds"

require "#{seeds}/destroy_old_data"
require "#{seeds}/themes"
require "#{seeds}/department"
require "#{seeds}/position"
require "#{seeds}/administrators"
User.find_by_email('retailingw@retaildoneright.com').make_current

require "#{seeds}/clients"
require "#{seeds}/projects"

require "#{seeds}/person"
require "#{seeds}/employee_ids"
# require "#{seeds}/technology_service_providers"
# require "#{seeds}/line_states"
# require "#{seeds}/lines"
# require "#{seeds}/models_and_manufacturers"
# require "#{seeds}/device_states"
# require "#{seeds}/devices"