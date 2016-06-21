# Author: Josh Bass
# Description: The React View for the Header bar at the top of the mast diagnostic display.

exports.getPrettyDate = (date_string) ->

  Date date = new Date(date_string)
  ret_val = (date.getMonth() + 1) + "/" + date.getDate() + "/" + date.getFullYear();
