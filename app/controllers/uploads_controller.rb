class UploadsController < ApplicationController
  def index
  end

  def new
  end

  def create
    file = params["upload"]["xml"]
    xml = Nokogiri::XML(file.open) { |c| c.strict.noblanks }
    CreatePayments.run(xml.root.children)
    # 1. redirect to /uploads/:upload_id/payments
    # 2. can we render individual react components at routes?
  end
end
