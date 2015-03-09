class SeedCandidateSources < ActiveRecord::Migration
  def up

    zip = CandidateSource.create name: 'Zip Recruiter', active: true
    builder = CandidateSource.create name: 'Career Builder', active: true
    craiglist = CandidateSource.create name: 'Craigslist', active: true
    web = CandidateSource.create name: 'Web Advertisement', active: true
    facebook = CandidateSource.create name: 'Facebook', active: true
    website = CandidateSource.create name: 'SalesMakers Website', active: true
    indeed = CandidateSource.create name: 'Indeed', active: true
    linkedin = CandidateSource.create name: 'LinkedIn', active: true
    simply = CandidateSource.create name: 'Simply Hired', active: true
    rookie = CandidateSource.create name: 'Career Rookie', active: true
    text = CandidateSource.create name: 'Text Message', active: true
    email = CandidateSource.create name: 'Email Invite', active: true
    fair = CandidateSource.create name: 'Job Fair', active: true
    college = CandidateSource.create name: 'College Job Board', active: true
    referral = CandidateSource.create name: 'Referral', active: true

  end

  def down
    CandidateSource.destroy_all
  end
end
