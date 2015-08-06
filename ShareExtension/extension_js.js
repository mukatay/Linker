var MMExtensionClass = function() {};

MMExtensionClass.prototype = {
run: function(arguments) {

    
    var description = "No description available";
    var imageURL = "unknown.jpg";
    var title = "Unknown";
    var pageURL = "";
    
    var metaTags = document.getElementsByTagName("meta");
    for (var i = 0; i < metaTags.length; i++) {
        if (metaTags[i].getAttribute("name") == "description") {
            description = metaTags[i].getAttribute("content");
        } else if (metaTags[i].getAttribute("property") == "og:image") {
            imageURL = metaTags[i].getAttribute("content");
        } else if (metaTags[i].getAttribute("property") == "og:url") {
            pageURL = metaTags[i].getAttribute("content");
        } else if (metaTags[i].getAttribute("property") == "og:title") {
            title = metaTags[i].getAttribute("content");
        }
    }
    
    arguments.completionFunction({"title" : title,
                                  "url" : pageURL,
                                  "description" : description,
                                  "imageURL" : imageURL });
},
    
finalize: function(arguments) {
    //document.body.innerHTML = arguments["content"];
}
};

var ExtensionPreprocessingJS = new MMExtensionClass;