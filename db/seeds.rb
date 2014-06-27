seeds = "#{Rails.root}/db/seeds"

require "#{seeds}/destroy_old_data"
require "#{seeds}/department"
require "#{seeds}/position"
require "#{seeds}/administrators"
User.find_by_email('retailingw@retaildoneright.com').make_current

require "#{seeds}/clients"
require "#{seeds}/projects"

require "#{seeds}/person"
require "#{seeds}/employee_ids"