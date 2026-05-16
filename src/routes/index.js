var express = require("express");
var router = express.Router();

router.get("/", function (req, res) {
    res.redirect("/HTML/Tela_home.html"); // redireciona para o HTML estático
});

module.exports = router;