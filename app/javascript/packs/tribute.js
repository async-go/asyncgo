import Tribute from "tributejs"
console.log("Hello")
var tribute = new Tribute({
values: [
        { key: "Phil Heartman", value: "Phil_Heartman" },
        { key: "Gordon Ramsey", value: "Gordon_Ramsey" }
    ]
    });
tribute.attach(document.querySelectorAll(".mentionable"));  