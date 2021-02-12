import Tribute from "tributejs"
console.log("Hello")
var tribute = new Tribute({
values: [
        { key: "Phil Heartman", value: "pheartman" },
        { key: "Gordon Ramsey", value: "gramsey" }
    ]
    });
tribute.attach(document.querySelectorAll(".mentionable"));  