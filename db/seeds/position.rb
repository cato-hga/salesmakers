puts "Creating positions..."
vonage_retail_sales = Department.find_by name: 'Vonage Sales'
vonage_event_sales = Department.find_by name: 'Vonage Event Sales'
sprint_prepaid_sales = Department.find_by name: 'Sprint Prepaid Sales'
comcast_retail_sales = Department.find_by name: 'Comcast Retail Sales'
unclassified_field = Department.find_by name: 'Unclassified Field'
unclassified_hq = Department.find_by name: 'Unclassified HQ'
training = Department.find_by name: 'Training'
recruiting = Department.find_by name: 'Recruiting'
information_technology = Department.find_by name: 'Information Technology'
operations = Department.find_by name: 'Operations'
accounting = Department.find_by name: 'Accounting and Finance'
marketing = Department.find_by name: 'Marketing'
quality_assurance = Department.find_by name: 'Quality Assurance'
executives = Department.find_by name: 'Executives'
payroll = Department.find_by name: 'Payroll'
hr = Department.find_by name: 'Human Resources'

tn = '+17272286225'

positions = [
                    { name: 'System Administrator',
                      leadership: true,
                      all_field_visibility: true,
                      all_corporate_visibility: true,
                      department_id: information_technology.id,
                      field: false,
                      hq: true,
                      twilio_number: tn },

                    { name: 'Vonage Regional Vice President',
                      leadership: true,
                      all_field_visibility: true,
                      all_corporate_visibility: true,
                      department_id: vonage_retail_sales.id,
                      field: true,
                      hq: false },
                    { name: 'Vonage Regional Manager',
                      leadership: true,
                      all_field_visibility: false,
                      all_corporate_visibility: false,
                      department_id: vonage_retail_sales.id,
                      field: true,
                      hq: false  },
                    { name: 'Vonage Area Sales Manager',
                      leadership: true,
                      all_field_visibility: false,
                      all_corporate_visibility: false,
                      department_id: vonage_retail_sales.id,
                      field: true,
                      hq: false  },
                    { name: 'Vonage Territory Manager',
                      leadership: true,
                      all_field_visibility: false,
                      all_corporate_visibility: false,
                      department_id: vonage_retail_sales.id,
                      field: true,
                      hq: false  },
                    { name: 'Vonage Sales Specialist',
                      leadership: false,
                      all_field_visibility: false,
                      all_corporate_visibility: false,
                      department_id: vonage_retail_sales.id,
                      field: true,
                      hq: false  },
                    { name: 'Vonage Event Regional Vice President',
                      leadership: true,
                      all_field_visibility: true,
                      all_corporate_visibility: true,
                      department_id: vonage_event_sales.id,
                      field: true,
                      hq: false },
                    { name: 'Vonage Event Regional Manager',
                      leadership: true,
                      all_field_visibility: false,
                      all_corporate_visibility: false,
                      department_id: vonage_event_sales.id,
                      field: true,
                      hq: false  },
                    { name: 'Vonage Event Area Sales Manager',
                      leadership: true,
                      all_field_visibility: false,
                      all_corporate_visibility: false,
                      department_id: vonage_event_sales.id,
                      field: true,
                      hq: false  },
                    { name: 'Vonage Event Team Leader',
                      leadership: true,
                      all_field_visibility: false,
                      all_corporate_visibility: false,
                      department_id: vonage_event_sales.id,
                      field: true,
                      hq: false  },
                    { name: 'Vonage Event Leader in Training',
                      leadership: true,
                      all_field_visibility: false,
                      all_corporate_visibility: false,
                      department_id: vonage_event_sales.id,
                      field: true,
                      hq: false  },
                    { name: 'Vonage Event Sales Specialist',
                      leadership: false,
                      all_field_visibility: false,
                      all_corporate_visibility: false,
                      department_id: vonage_event_sales.id,
                      field: true,
                      hq: false  },
                    { name: 'Sprint Prepaid Regional Vice President',
                      leadership: true,
                      all_field_visibility: false,
                      all_corporate_visibility: false,
                      department_id: sprint_prepaid_sales.id,
                      field: true,
                      hq: false  },
                    { name: 'Sprint Prepaid Regional Manager',
                      leadership: true,
                      all_field_visibility: false,
                      all_corporate_visibility: false,
                      department_id: sprint_prepaid_sales.id,
                      field: true,
                      hq: false  },
                    { name: 'Sprint Prepaid Area Sales Manager',
                      leadership: true,
                      all_field_visibility: false,
                      all_corporate_visibility: false,
                      department_id: sprint_prepaid_sales.id,
                      field: true,
                      hq: false  },
                    { name: 'Sprint Prepaid Sales Director',
                      leadership: true,
                      all_field_visibility: false,
                      all_corporate_visibility: false,
                      department_id: sprint_prepaid_sales.id,
                      field: true,
                      hq: false  },
                    { name: 'Sprint Prepaid Sales Specialist',
                      leadership: false,
                      all_field_visibility: false,
                      all_corporate_visibility: false,
                      department_id: sprint_prepaid_sales.id,
                      field: true,
                      hq: false  },
                    { name: 'Comcast Retail Regional Vice President',
                      leadership: true,
                      all_field_visibility: false,
                      all_corporate_visibility: false,
                      department_id: comcast_retail_sales.id,
                      field: true,
                      hq: false  },
                    { name: 'Comcast Retail Territory Manager',
                      leadership: true,
                      all_field_visibility: false,
                      all_corporate_visibility: false,
                      department_id: comcast_retail_sales.id,
                      field: true,
                      hq: false  },
                    { name: 'Comcast Retail Sales Specialist',
                      leadership: false,
                      all_field_visibility: false,
                      all_corporate_visibility: false,
                      department_id: comcast_retail_sales.id,
                      field: true,
                      hq: false  },
                    { name: 'Unclassified Field Employee',
                      leadership: false,
                      all_field_visibility: false,
                      all_corporate_visibility: false,
                      department_id: unclassified_field.id,
                      field: true,
                      hq: false },
                    { name: 'Unclassified HQ Employee',
                      leadership: false,
                      all_field_visibility: false,
                      all_corporate_visibility: false,
                      department_id: unclassified_hq.id,
                      field: false,
                      hq: true },
                    { name: 'Training Director',
                      leadership: true,
                      all_field_visibility: true,
                      all_corporate_visibility: true,
                      department_id: training.id,
                      field: false,
                      hq: true },
                    { name: 'Trainer',
                      leadership: false,
                      all_field_visibility: true,
                      all_corporate_visibility: true,
                      department_id: training.id,
                      field: false,
                      hq: true },
                    { name: 'Advocate Director',
                      leadership: true,
                      all_field_visibility: true,
                      all_corporate_visibility: false,
                      department_id: recruiting.id,
                      field: false,
                      hq: true },
                    { name: 'Advocate Supervisor',
                      leadership: true,
                      all_field_visibility: true,
                      all_corporate_visibility: false,
                      department_id: recruiting.id,
                      field: false,
                      hq: true },
                    { name: 'Advocate',
                      leadership: false,
                      all_field_visibility: true,
                      all_corporate_visibility: false,
                      department_id: recruiting.id,
                      field: false,
                      hq: true },
                    { name: 'Recruiting Call Center Director',
                      leadership: true,
                      all_field_visibility: true,
                      all_corporate_visibility: false,
                      department_id: recruiting.id,
                      field: false,
                      hq: true },
                    { name: 'Recruiting Call Center Representative',
                      leadership: false,
                      all_field_visibility: true,
                      all_corporate_visibility: false,
                      department_id: recruiting.id,
                      field: false,
                      hq: true },
                    { name: 'Senior Software Developer',
                      leadership: true,
                      all_field_visibility: true,
                      all_corporate_visibility: true,
                      department_id: information_technology.id,
                      field: false,
                      hq: true,
                      twilio_number: tn },
                    { name: 'Software Developer',
                      leadership: false,
                      all_field_visibility: true,
                      all_corporate_visibility: true,
                      department_id: information_technology.id,
                      field: false,
                      hq: true,
                      twilio_number: tn },
                    { name: 'Information Technology Director',
                      leadership: true,
                      all_field_visibility: true,
                      all_corporate_visibility: true,
                      department_id: information_technology.id,
                      field: false,
                      hq: true,
                      twilio_number: tn },
                    { name: 'Information Technology Support Technician',
                      leadership: false,
                      all_field_visibility: true,
                      all_corporate_visibility: true,
                      department_id: information_technology.id,
                      field: false,
                      hq: true,
                      twilio_number: tn },
                    { name: 'Operations Director',
                      leadership: true,
                      all_field_visibility: true,
                      all_corporate_visibility: true,
                      department_id: operations.id,
                      field: false,
                      hq: true },
                    { name: 'Operations Coordinator',
                      leadership: false,
                      all_field_visibility: true,
                      all_corporate_visibility: true,
                      department_id: operations.id,
                      field: false,
                      hq: true },
                    { name: 'Inventory Coordinator',
                      leadership: false,
                      all_field_visibility: true,
                      all_corporate_visibility: true,
                      department_id: operations.id,
                      field: false,
                      hq: true },
                    { name: 'Reporting Coordinator',
                      leadership: false,
                      all_field_visibility: true,
                      all_corporate_visibility: true,
                      department_id: operations.id,
                      field: false,
                      hq: true },
                    { name: 'Finance Administrator',
                      leadership: false,
                      all_field_visibility: true,
                      all_corporate_visibility: true,
                      department_id: accounting.id,
                      field: false,
                      hq: true },
                    { name: 'Controller',
                      leadership: true,
                      all_field_visibility: true,
                      all_corporate_visibility: true,
                      department_id: accounting.id,
                      field: false,
                      hq: true },
                    { name: 'Accountant',
                      leadership: false,
                      all_field_visibility: true,
                      all_corporate_visibility: true,
                      department_id: accounting.id,
                      field: false,
                      hq: true },
                    { name: 'Marketing Director',
                      leadership: true,
                      all_field_visibility: true,
                      all_corporate_visibility: true,
                      department_id: marketing.id,
                      field: false,
                      hq: true },
                    { name: 'Quality Assurance Director',
                      leadership: true,
                      all_field_visibility: true,
                      all_corporate_visibility: true,
                      department_id: quality_assurance.id,
                      field: false,
                      hq: true },
                    { name: 'Quality Assurance Administrator',
                      leadership: false,
                      all_field_visibility: true,
                      all_corporate_visibility: true,
                      department_id: quality_assurance.id,
                      field: false,
                      hq: true },
                    { name: 'Chief Executive Officer',
                      leadership: true,
                      all_field_visibility: true,
                      all_corporate_visibility: true,
                      department_id: executives.id,
                      field: false,
                      hq: true },
                    { name: 'Chief Operations Officer',
                      leadership: true,
                      all_field_visibility: true,
                      all_corporate_visibility: true,
                      department_id: executives.id,
                      field: false,
                      hq: true },
                    { name: 'Chief Financial Officer',
                      leadership: true,
                      all_field_visibility: true,
                      all_corporate_visibility: true,
                      department_id: executives.id,
                      field: false,
                      hq: true },
                    { name: 'Vice President of Sales',
                      leadership: true,
                      all_field_visibility: true,
                      all_corporate_visibility: true,
                      department_id: executives.id,
                      field: false,
                      hq: true },
                    { name: 'Executive Assistant',
                      leadership: false,
                      all_field_visibility: true,
                      all_corporate_visibility: true,
                      department_id: executives.id,
                      field: false,
                      hq: true },
                    { name: 'Payroll Director',
                      leadership: true,
                      all_field_visibility: true,
                      all_corporate_visibility: true,
                      department_id: payroll.id,
                      field: false,
                      hq: true },
                    { name: 'Payroll Administrator',
                      leadership: false,
                      all_field_visibility: true,
                      all_corporate_visibility: true,
                      department_id: payroll.id,
                      field: false,
                      hq: true },
                    { name: 'Human Resources Director',
                      leadership: false,
                      all_field_visibility: true,
                      all_corporate_visibility: true,
                      department_id: hr.id,
                      field: false,
                      hq: true },
                    { name: 'Human Resources Administrator',
                      leadership: false,
                      all_field_visibility: true,
                      all_corporate_visibility: true,
                      department_id: hr.id,
                      field: false,
                      hq: true }
                ]

for position in positions do
  Position.find_or_create_by position
end