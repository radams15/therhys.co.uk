function onDropDown() {
    var x = document.getElementById("main_nav");
    
    if (x.className === "navbar") {
        x.className = "navbar responsive";
    } else {
        x.className = "navbar";
    }
}
