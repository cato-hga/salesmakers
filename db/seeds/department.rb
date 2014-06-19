puts "Creating departments..."
Department.create [
                      { name: 'Unclassified Field', corporate: false },
                      { name: 'Unclassified Corporate', corporate: true },
                      { name: 'Advocates', corporate: true },
                      { name: 'Human Resources', corporate: true },
                      { name: 'Vonage Retail Sales', corporate: false },
                      { name: 'Vonage Event Sales', corporate: false },
                      { name: 'Training', corporate: true },
                      { name: 'Operations', corporate: true },
                      { name: 'Information Technology', corporate: true }
                  ]