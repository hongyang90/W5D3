require 'json'

class Session
  # find the cookie for this app
  # deserialize the cookie into a hash
  # attr_reader :cookie

  def initialize(req)
     req.cookies['_rails_lite_app'] ? @cookie = JSON.parse(req.cookies['_rails_lite_app']) : @cookie = {}
  end


  def [](key)
   @cookie[key]
  end
  
  def []=(key, val) 
    @cookie[key] = val
  end

  # serialize the hash into json and save in a cookie
  # add to the responses cookies
  def store_session(res)
    json_cookie = @cookie.to_json
    res.set_cookie("_rails_lite_app", {path: "/", value: json_cookie})
  end
end
