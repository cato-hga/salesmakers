puts "Creating departments..."
Department.create [
  { name: 'Vonage Retail Sales', corporate: false },
  { name: 'Vonage Event Sales', corporate: false },
  { name: 'Sprint Retail Sales', corporate: false },
  { name: 'Unclassified Field', corporate: false },
  { name: 'Unclassified HQ', corporate: true },

  { name: 'Training', corporate: true },
  { name: 'Recruiting', corporate: true },
  { name: 'Information Technology', corporate: true },
  { name: 'Operations', corporate: true },
  { name: 'Accounting and Finance', corporate: true },
  { name: 'Marketing', corporate: true },
  { name: 'Quality Assurance', corporate: true },
  { name: 'Executives', corporate: true },
  { name: 'Payroll', corporate: true },
  { name: 'Human Resources', corporate: true },
]