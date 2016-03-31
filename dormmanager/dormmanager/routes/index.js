var express = require('express');
var router = express.Router();

// MySQL Setup
var mysql = require('mysql');
var connection = mysql.createConnection(
    {
      host     : 'jakesserver',
      user     : 'jake',
      password : 'jake',
      database : 'dorm',
    }
);
connection.connect();
 
/* GET home page. */
router.get('/', function(req, res, next) {
  //res.render('index', { title: 'Express' });
  res.sendFile("index.html");
});

router.post("/login", function(req, res, next) {
  // A login was attepted
  console.log("\nLogin Attempted");
  console.log(req.body);

  // Generate login QUERY
  var id = req.body.id;
  var password = req.body.password;
  var query = "SELECT * FROM students WHERE ID='" + id + "' AND Password='" + password + "'";
  connection.query(query, function(err, rows, fields) {
    console.log(query);
    if(err) throw err;
    if(!isNaN(id) && rows.length > 0) {
      res.send({type: "success", data: "student/g/"});
    } else {
      res.send({type: "fail", data: "Invalid username or password"});
    }
  });
});


module.exports = router;
