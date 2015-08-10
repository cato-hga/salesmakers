module AuthorizedAPI
  def doGet(path, query = nil)
    query_hash = authorization_hash
    query_hash = query_hash.merge query if query
    self.class.get path, { query: query_hash, headers: { 'Content-Type' => 'application/json',
                                                         'Accept' => 'application/json' } }
  end

  def doPost(path, body, query = nil)
    query_hash = authorization_hash
    query_hash = query_hash.merge query if query
    self.class.post path, { body: body, query: query_hash, headers: { 'Content-Type' => 'application/json',
                                                                      'Accept' => 'application/json' } }
  end
end