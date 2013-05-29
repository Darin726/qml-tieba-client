WorkerScript.onMessage = function(message){
                 var list = message.list;
                 var model = message.model;
                 var option = message.option;
                 if (option == "favo"){
                     loadFavo(list, model);
                 } else if (option == "sug"){
                     loadSug(list, model);
                 } else if (option == "search"){
                     if (message.renew) model.clear();
                     loadSearch(list, model);
                 } else if (option == "timeline"){
                     loadTimeline(list, model);
                 }
                 model.sync();
             }

function loadFavo(list, model){
    model.clear();
    list.forEach(function(value){
                     if (value.is_like == 1) model.append(value);
                 })
}

function loadSug(list, model){
    model.clear();
    list.forEach(function(value){
                     model.append({"name": value});
                 })
}

function loadSearch(list, model){
    list.forEach(function(value){
                     model.append({
                                      "pid": value.pid,
                                      "title": value.title,
                                      "time": value.time,
                                      "content": value.content,
                                      "fname": value.fname,
                                      "tid": value.tid,
                                      "is_floor": value.is_floor,
                                      "name": value.author.name_show
                                  })
                 })
}

function loadTimeline(list, model){
    list.forEach(function(value){
                     model.append({
                                      "title": value.title,
                                      "type": value.type,
                                      "fname": value.fname,
                                      "reply_time": value.reply_time,
                                      "reply_num": value.reply_num,
                                      "pid": value.pid,
                                      "tid": value.tid,
                                      "is_floor": value.is_floor,
                                      "time_shaft": value.time_shaft
                                  })
                 })
}
