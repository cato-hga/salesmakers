puts "Setting up line states..."
active = LineState.create name: 'Active', locked: true
suspended = LineState.create name: 'Suspended', locked: true