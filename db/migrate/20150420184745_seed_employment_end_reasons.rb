class SeedEmploymentEndReasons < ActiveRecord::Migration
  def change
    reasons = [
        'M100 Profanity',
        'M101 Theft of company property',
        'M102 Destruction of Property',
        'M103 Sleeping on the Job',
        'M104 Intoxication',
        'M105 Dishonesty',
        'M106 Fraud',
        'M107 Time Theft',
        'M108 Refusal to work',
        'M109 Attendance - tardiness',
        'M110 Rule or Policy Violation',
        'M111 Insubordination',
        'M112 Conflict of Interest',
        'M113 No Call No Show',
        'P100 Poor Performance',
        'P101 Quota not met',
        'S100 Death',
        'S101 Natural Disaster',
        'T100  Failed Studio Training',
        'T101 Released During 90 Day Probationary Period',
        'T102 Application for employment falsified (advocate or HR use only)',
        'T103 Required Drug Screen Fail (HR Use only)',
        'T104 Required background check fail (HR Use Only)',
        'T105 I-9 documenation - requirement not met (Advocate/HR use only)',
        'T106 Refusal to take Drug Screening',
        'T107 Workmens comp settlement (HR Use Only)',
        'T108 Released Prior to Working',
        'T109 Job Abandonment Training S1',
        'T110 Job Abandonment Training S3',
        'V100 Health Reasons unrelated to the job',
        'V101 Health reasons related to the job',
        'V102 Job Abandonment',
        'V103 Job Disatisfaction',
        'V104 Personal Reasons',
        'V105 Accepted Another Job',
        'V106 Walked off the Job',
        'Y100 Reduction in force',
        'Y101 Reorganization',
        'Y102 Job Eliminated',
        'Y103 Temp layoff',
        'Y104 Project Ended'
    ]

    for reason in reasons do
      EmploymentEndReason.create name: reason, active: true
    end
  end
end
