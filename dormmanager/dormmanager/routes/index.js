var express = require('express');
var router = express.Router();

/* GET home page. */
router.get('/', function(req, res, next) {
  //res.render('index', { title: 'Express' });
  res.sendFile("index.html");
});

router.post("/login", function(req, res, next) {
  console.log(req.body);
  if(req.body.password==="abc") {
    res.redirect("test.html");
  } else {
    res.send({type: "joby is a numnut"});
  }
});

module.exports = router;
