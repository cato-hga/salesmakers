class AddNewMissingIndexes < ActiveRecord::Migration
  def change
    add_index :workmarket_assignments, :project_id
    add_index :workmarket_assignments, :workmarket_location_num
    add_index :candidate_availabilities, :candidate_id
    add_index :vonage_rep_sale_payout_brackets, :area_id
    add_index :training_time_slots, :training_class_type_id
    add_index :training_time_slots, :person_id
    add_index :training_class_types, :project_id
    add_index :sprint_sales, :person_id
    add_index :sprint_sales, :location_id
    add_index :sprint_sales, :connect_sprint_sale_id
    add_index :screenings, :person_id
    add_index :location_areas_radio_shack_location_schedules, [:location_area_id, :radio_shack_location_schedule_id], name: 'location_areas_location_areas_rs_schedules'
    add_index :location_areas_radio_shack_location_schedules, :radio_shack_location_schedule_id, name: 'location_areas_rs_schedules'
    add_index :location_areas_radio_shack_location_schedules, :location_area_id, name: 'location_areas_location_areas'
    add_index :prescreen_answers, :candidate_id
    add_index :person_pay_rates, :person_id
    add_index :workmarket_fields, :workmarket_assignment_id
    add_index :workmarket_attachments, :workmarket_assignment_id
    add_index :person_addresses, :person_id
    add_index :client_representatives_permissions, :client_representative_id, name: 'client_rep_perms_client_rep'
    add_index :client_representatives_permissions, [:client_representative_id, :permission_id], name: 'client_rep_perms_client_rep_perm'
    add_index :client_representatives_permissions, :permission_id, name: 'client_rep_perms_perm'
    add_index :location_areas, :location_id
    add_index :location_areas, :area_id
    add_index :location_areas, [:area_id, :location_id]
    add_index :locations, :channel_id
    add_index :locations, :sprint_radio_shack_training_location_id
    add_index :interview_answers, :candidate_id
    add_index :email_messages, :to_person_id
    add_index :docusign_noses, :person_id
    add_index :docusign_noses, :employment_end_reason_id
    add_index :directv_former_providers, :directv_sale_id
    add_index :directv_eods, :location_id
    add_index :directv_eods, :person_id
    add_index :directv_customer_notes, :directv_customer_id
    add_index :directv_customer_notes, :person_id
    add_index :directv_customers, :person_id
    add_index :directv_customers, :location_id
    add_index :comcast_sales, :comcast_customer_id
    add_index :comcast_sales, :person_id
    add_index :comcast_leads, :comcast_customer_id
    add_index :comcast_group_me_bots, :area_id
    add_index :comcast_customers, :person_id
    add_index :comcast_customers, :location_id
    add_index :client_representatives, :client_id
    add_index :changelog_entries, :project_id
    add_index :changelog_entries, :department_id
    add_index :candidate_reconciliations, :candidate_id
    add_index :candidate_notes, :candidate_id
    add_index :candidate_notes, :person_id
    add_index :candidate_contacts, :candidate_id
    add_index :candidate_contacts, :person_id
    add_index :area_candidate_sourcing_groups, :project_id
    add_index :people_poll_question_choices, [:poll_question_choice_id, :person_id], name: 'poll_q_choices_poll_q_choice_person'
    add_index :areas, :area_candidate_sourcing_group_id
    add_index :candidates, :location_area_id
    add_index :candidates, :person_id
    add_index :candidates, :candidate_source_id
    add_index :candidates, :candidate_denial_reason_id
    add_index :candidates, :created_by
    add_index :candidates, :sprint_radio_shack_training_session_id
    add_index :candidates, :potential_area_id
    add_index :candidate_drug_tests, :candidate_id
    add_index :comcast_customer_notes, :comcast_customer_id
    add_index :comcast_customer_notes, :person_id
    add_index :comcast_eods, :location_id
    add_index :comcast_eods, :person_id
    add_index :comcast_former_providers, :comcast_sale_id
    add_index :comcast_install_appointments, :comcast_sale_id
    add_index :comcast_install_appointments, :comcast_install_time_slot_id, name: 'comcast_inst_appts_time_slot'
    add_index :communication_log_entries, :person_id
    add_index :directv_install_appointments, :directv_sale_id
    add_index :directv_install_appointments, :directv_install_time_slot_id, name: 'directv_inst_appts_time_slot'
    add_index :directv_leads, :directv_customer_id
    add_index :directv_sales, :directv_customer_id
    add_index :directv_sales, :person_id
    add_index :docusign_templates, :project_id
    add_index :interview_schedules, :candidate_id
    add_index :interview_schedules, :person_id
    add_index :job_offer_details, :candidate_id
    add_index :sms_messages, :to_person_id
    add_index :sms_messages, :from_person_id
    add_index :sms_messages, :to_candidate_id
    add_index :sms_messages, :from_candidate_id
    add_index :sprint_group_me_bots, :area_id
    add_index :sprint_pre_training_welcome_calls, :candidate_id
    add_index :training_availabilities, :training_unavailability_reason_id, name: 'train_avail_unavail_reason'
    add_index :training_availabilities, :candidate_id
    add_index :training_classes, :training_class_type_id
    add_index :training_classes, :training_time_slot_id
    add_index :training_classes, :person_id
    add_index :training_class_attendees, :person_id
    add_index :training_class_attendees, :training_class_id
    add_index :vonage_paycheck_negative_balances, :person_id
    add_index :vonage_paycheck_negative_balances, :vonage_paycheck_id, name: 'vonage_paycheck_neg_bal_paycheck'
    add_index :vonage_refunds, :vonage_sale_id
    add_index :vonage_refunds, :vonage_account_status_change_id
    add_index :vonage_refunds, :person_id
    add_index :vonage_sales, :person_id
    add_index :vonage_sales, :location_id
    add_index :vonage_sales, :vonage_product_id
    add_index :vonage_sales, :connect_order_uuid
    add_index :vonage_sale_payouts, :vonage_sale_id
    add_index :vonage_sale_payouts, :person_id
    add_index :vonage_sale_payouts, :vonage_paycheck_id
  end
end
