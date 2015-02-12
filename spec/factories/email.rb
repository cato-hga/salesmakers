FactoryGirl.define do

  factory :email, class: OpenStruct do
    # Assumes Griddler.configure.to is :hash (default)
    to [
           {
               full: 'to_user@email.com',
               email: 'to_user@email.com',
               token: 'to_user',
               host: 'email.com',
               name: nil
           }
       ]
    from({
             token: 'from_user',
             host: 'email.com',
             email: 'from_email@email.com',
             full: 'From User <from_user@email.com>',
             name: 'From User'
         })
    subject 'email subject'
    body 'Hello!'
    attachments {[]}

    trait :with_vonage_account_excel_attachment do
      attachments {[
          ActionDispatch::Http::UploadedFile.new({
                                                     filename: 'UQube Import for FTP.xlsx',
                                                     type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
                                                     tempfile: File.new(Rails.root.join('spec', 'fixtures', 'UQube Import for FTP.xlsx'))
                                                 })
      ]}
    end
  end
end