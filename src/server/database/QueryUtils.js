
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
        }
        query.$and.push(query_part);
      }
    }
  }
  console.log("here is our query");
  console.log(query);
  return query;

}
