module UsersHelper
  def grass_color(count)
    return "bg-gray-100" if count.nil? || count == 0
    case count
    when 1..2 then "bg-green-200"
    when 3..5 then "bg-green-400"
    when 6..9 then "bg-green-600"
    else           "bg-green-800"
    end
  end
end
