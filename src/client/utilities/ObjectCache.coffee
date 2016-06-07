# Author: Josh Bass
# Description: The React View for the Header bar at the top of the mast diagnostic display.

module.exports = class ObjectCache

  constructor: (options) ->

    options = if options then options else {};
    @max_size = if options.max_size then options.max_size else 50;
    @cull_time = if options.cull_time then options.cull_time else 5000;

    @cache = {};
    @cache_list = [];

    @interval_task = window.setInterval(() =>
      if (@cache_list.length > 50)
        offset = @cache_list.length - 50;
        for i in [0..offset]
          delete @cache[@cache_list[i].attr];
        @cache_list.splice(0, offset);

    , 5000);

  get: (attr) ->
    if (@cache[attr])
      @cache[attr].object;
    else
      undefined;

  put: (attr, object) ->

    if (!@cache[attr])
      obj = {attr: attr, time: new Date(), object: object};
      @cache[attr] = obj;
      @cache_list.push(obj);
      @cache_list.sort((a, b) =>
        if (a.time.getTime() > b.time.getTime())
          return 1;
        else if (a.time.getTime() < b.time.getTime())
          return -1;
        return 0;
      );

  destroy: () ->
    window.clearInterval(@interval_task);
