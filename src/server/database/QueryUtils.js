
exports.buildQuery = function(filters){

  var query = {};

  if (filters){
    console.log("lets build a query");
    console.log(filters);
    query = {$and: []};

    for (var filter_list in filters){
      for (var filter of filters[filter_list]){
        query_part = {};
        if (filter.type == "text"){
          if (filter.modifier == "is"){
            query_part[filter.key] = filter.value;
          }else if (filter.modifier == "is not"){
            query_part[filter.key] = {$ne: filter.value};
          }else if (filter.modifier == "contains"){
            query_part[filter.key] = {$regex: filter.value};
          }
        }else if (filter.type == "number"){
          var number_value = parseFloat(filter.value);
          if (filter.modifier == "equals"){
            query_part[filter.key] = number_value;
          }else if(filter.modifier == "!equals"){
            query_part[filter.key] = {$ne: number_value};
          }else if (filter.modifier == "< lt"){
            query_part[filter.key] = {$lt: number_value};
          }else if (filter.modifier == "> gt"){
            query_part[filter.key] = {$gt: number_value};
          }
        }else if (filter.type == "date"){
          console.log("date is");
          console.log(filter.value);
          var date = new Date(filter.value)
          if (filter.modifier == "is"){
            query_part[filter.key] = date;
          }else if(filter.modifier == "before"){
            query_part[filter.key] = {$lt: date};
          }else if (filter.modifier == "after"){
            query_part[filter.key] = {$gt: date};
          }
        }
        query.$and.push(query_part);
      }
    }
  }
  console.log("here is our query");
  console.log(query);
  return query;

}
