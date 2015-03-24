class SeedOutsourcedAndJobFairCandidateSources < ActiveRecord::Migration
  def self.up
    CandidateSource.create name: 'Outsourced', active: true
  end

  def self.down
    CandidateSource.where(name: 'Outsourced').destroy_all
  end
end
