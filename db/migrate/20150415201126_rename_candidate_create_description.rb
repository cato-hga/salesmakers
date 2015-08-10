class RenameCandidateCreateDescription < ActiveRecord::Migration
  def self.up
    permission = Permission.find_by key: 'candidate_create', description: 'Can view candidates'
    permission.destroy if permission
    permission = Permission.find_by key: 'candidate_index', description: 'can view index of Candidates'
    permission.destroy if permission
    permission = Permission.find_by key: 'candidate_view_all'
    permission.update description: "can view all recruiter's candidates and view the support search page" if permission
    permission = Permission.find_by key: 'candidate_index'
    permission.update description: 'can view the candidates list' if permission

    for permission in Permission.all do
      new_description = permission.
          description.
          downcase.
          gsub('comcast', 'Comcast').
          gsub('groupme', 'GroupMe').
          gsub('_', ' ').
          gsub('can ', '')
      permission.update description: new_description
    end
  end
end
