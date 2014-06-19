class User < Person
  #Making every Person a User for Sentient User gem compatibility
  include SentientUser
end