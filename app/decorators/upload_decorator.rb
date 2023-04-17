class UploadDecorator < SimpleDelegator
  def initialize(upload)
    super(upload)
  end

  def as_json(*)
    {
      "id" => id,
      "status" => status,
      "payments" => payments.length,
      "created_at_time" => created_at.strftime("%l:%M %p").split(" "),
      "created_at_date" => created_at.strftime("%b %-d %Y").split(" "),
      "updated_at_time" => updated_at.strftime("%l:%M %p").split(" "),
      "updated_at_date" => updated_at.strftime("%b %-d %Y").split(" ")
    }
  end
end
