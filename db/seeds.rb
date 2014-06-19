seeds = "#{Rails.root}/db/seeds"

require "#{seeds}/destroy_old_data"
require "#{seeds}/department"
require "#{seeds}/position"
require "#{seeds}/administrators"