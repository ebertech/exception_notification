class ExceptionNotification::FakeRequest
  def env
    ENV
  end
  
  def protocol
    "N/A"
  end
  
  def request_uri
    ""
  end
  
  def parameters
    {}
  end
  
  def session_options
    {}
  end
  
  def session
    "N/A"
  end
end