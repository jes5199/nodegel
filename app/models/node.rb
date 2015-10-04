class Node < ActiveRecord::Base
  belongs_to :author, class_name: "User"

  def render_body
    return self.body.gsub("\n", "<br>\n").html_safe
  end
end
