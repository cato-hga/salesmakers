class InsertPollQuestionPermissions < ActiveRecord::Migration
  def self.up
    pos_admin = Position.find_by_name 'System Administrator'
    pos_ceo = Position.find_by_name 'Chief Executive Officer'
    pos_coo = Position.find_by_name 'Chief Operations Officer'
    pos_cfo = Position.find_by_name 'Chief Financial Officer'
    pos_vps = Position.find_by_name 'Vice President of Sales'
    pos_ea = Position.find_by_name 'Executive Assistant'
    pos_od = Position.find_by_name 'Operations Director'
    pos_oc = Position.find_by_name 'Operations Coordinator'
    pos_ic = Position.find_by_name 'Inventory Coordinator'
    pos_rc = Position.find_by_name 'Reporting Coordinator'
    pos_qad = Position.find_by_name 'Quality Assurance Director'
    pos_qaa = Position.find_by_name 'Quality Assurance Administrator'
    pos_ssd = Position.find_by_name 'Senior Software Developer'
    pos_sd = Position.find_by_name 'Software Developer'
    pos_itd = Position.find_by_name 'Information Technology Director'
    pos_md = Position.find_by_name 'Marketing Director'
    positions = [
        pos_admin,
        pos_ceo,
        pos_coo,
        pos_cfo,
        pos_vps,
        pos_ea,
        pos_od,
        pos_oc,
        pos_ic,
        pos_rc,
        pos_qad,
        pos_qaa,
        pos_ssd,
        pos_sd,
        pos_itd,
        pos_md
    ]
    poll_questions_permission_group = PermissionGroup.create name: 'Poll Questions'
    poll_question_manage = Permission.create key: 'poll_question_manage',
                                             description: 'can manage poll questions',
                                             permission_group: poll_questions_permission_group
    poll_question_show = Permission.create key: 'poll_question_show',
                                           description: 'can view all poll question results',
                                           permission_group: poll_questions_permission_group
    for position in positions do
      next unless position
      position.permissions << poll_question_manage
      position.permissions << poll_question_show
    end
  end

  def self.down
    poll_question_manage = Permission.find_by key: 'poll_question_manage'
    poll_question_show = Permission.find_by key: 'poll_question_show'
    poll_questions_permission_group = PermissionGroup.find_by name: 'Poll Questions'
    poll_question_manage.destroy
    poll_question_show.destroy
    poll_questions_permission_group.destroy
  end
end
