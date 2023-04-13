class SuccessResult
  attr_reader :payload

  def initialize(payload)
    @payload = payload
  end

  def success?
    true
  end

  def failure?
    false
  end

  def error
    ""
  end
end
