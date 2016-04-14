var express = require('express');
var router = express.Router();

// MySQL Setup
var mysql = require('mysql');
var connection = mysql.createConnection({
	host: 'jakesserver',
	user: 'jake',
	password: 'jake',
	database: 'dorm',
});
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
		if (err) {
			success = false;
		} else {
			if (!isNaN(id) && rows.length > 0) {
				var query2 = "SELECT * FROM groupmembers WHERE Student_ID='" + id + "'";
				connection.query(query2, function(err2, rows2, fields2) {
					console.log(query2);
					if (err2) {
						Console.log("Group check query failed");
					} else {
						var location;
						if (rows2.length > 0) {
							location = "student/g/";
						} else {
							location = "student/ng/";
						}
						console.log("Sending to " + location);
						res.send({
							type: "success",
							data: location
						});
					}
				});

			} else {
				res.send({
					type: "fail",
					data: "Invalid username or password"
				});
			}
		}
	});
});

router.post("/student/g/", function(req, res, next) {

	if (req.body.request === "details") {
		// A login was attepted
		console.log("\nGroup details requested");
		console.log(req.body);

		// Generate login QUERY
		var id = req.body.id;

		var groupNum;
		var members;
		var buildingName;
		var roomNum;

		// Get group number
		var p1 = getGroup_ID(id);
		p1.then(function(p_Group_ID) {
			groupNum = p_Group_ID;

			// use group number to get all student id's from group
			var p2 = getGroupMemberNames(groupNum, id);
			p2.then(function(p_Members) {
				members = p_Members;

				var p3 = getRoomNumber(groupNum);
				p3.then(function(p_room) {

					var p4 = getRoomBuilding(p_room);
					p4.then(function(p_bname) {
						res.send({
							type: "success",
							data: {
								groupNum: groupNum,
								members: members,
								buildingName: p_bname,
								roomNum: p_room
							}
						});
					}).catch(function(reason) {
						fail("Could not get room name: " + reason);
					});
				}).catch(function(reason) {
					fail("Could not get room number: " + reason);
				});
			}).catch(function(reason) {
				fail("Could not get group members: " + reason);
			});
		}).catch(function(reason) {
			fail("Could not get group number: " + reason);
		});
	} else if (req.body.request === "leave_group") {
		var p1 = leave_group(req.body.id);
		p1.then(function(location) {
			res.send({
				type: "success",
				data: {
					location: location
				}
			});
		}).catch(function(reason) {
			fail("Could not leave group number: " + reason);
		});
	}
});

router.post("/student/ng/", function(req, res, next) {

	if (req.body.request === "join_group") {
		// A login was attepted
		console.log("\nJoin group requested");
		console.log(req.body);

		// Generate login QUERY
		var id = req.body.id;
		var gid = req.body.gid;

		// Get group number
		var p1 = join_group(id, gid);
		p1.then(function(newLocation) {
			res.send({
				type: "success",
				data: {
					location: newLocation
				}
			});
		}).catch(function(reason) {
			fail("Could not get group number: " + reason);
		});
	}
});

function fail(reason) {
	res.send({
		type: "fail",
		data: reason
	});
	console.log("request failed: " + reason);
}

function getGroup_ID(Student_ID) {
	var query1 = "SELECT Group_ID FROM groupmembers WHERE Student_ID='" + Student_ID + "'";
	return new Promise(function(resolve, reject) {
		connection.query(query1, function(err, rows, fields) {
			var Group_ID;
			console.log(query1);
			if (err) {
				console.log(err);
				reject("Error in query: " + err);
			} else {
				if (rows.length > 0) {
					Group_ID = rows[0].Group_ID;
					console.log("Group_ID = " + Group_ID);
					resolve(Group_ID);
				} else {
					reject("No Group_ID found");
				}
			}
		});
	});
}

function getGroupMemberNames(Group_ID, Student_ID) {
	var query = "SELECT Name FROM students INNER JOIN groupmembers ON students.ID=groupmembers.Student_ID WHERE groupmembers.Group_ID='" + Group_ID + "' AND Student_ID!='" + Student_ID + "'";
	return new Promise(function(resolve, reject) {
		connection.query(query, function(err, rows, fields) {
			console.log(query);
			if (err) {
				reject("Error in query: " + err);
			} else {
				if (rows.length > 0) {
					console.log("Members:");
					for (i = 0; i < rows.length; i++) {
						console.log("\t" + rows[i].Name);
					}
					resolve(rows);
				} else {
					reject("No group members found");
				}
			}
		});
	});
}

function leave_group(Student_ID) {
	var query = "DELETE FROM groupmembers WHERE Student_ID='" + Student_ID + "'";
	return new Promise(function(resolve, reject) {
		connection.query(query, function(err, rows, fields) {
			console.log(query);
			if (err) {
				reject("Error in query: " + err);
			} else {
				resolve("/student/ng/");
			}
		});
	});
}

function join_group(Student_ID, Group_ID) {
	var query = "INSERT INTO groupmembers (Student_ID, Group_ID) VALUES ('" + Student_ID + "','" + Group_ID + "')";
	return new Promise(function(resolve, reject) {
		connection.query(query, function(err, rows, fields) {
			console.log(query);
			if (err) {
				reject("Error in query: " + err);
			} else {
				resolve("/student/g/");
			}
		});
	});
}

function getRoomNumber(Group_ID) {
	var query = "SELECT Room_Number FROM studentrooms WHERE Group_ID='" + Group_ID + "'";
	return new Promise(function(resolve, reject) {
		connection.query(query, function(err, rows, fields) {
			console.log(query);
			if (err) {
				reject("Error in query: " + err);
			} else {
				if (rows.length > 0) {
					console.log("Room number: " + rows[0].Room_Number)
					resolve(rows[0].Room_Number);
				} else {
					console.log("Room number: Not set");
					resolve("Not set");
				}
			}
		});
	});
}

function getRoomBuilding(Room_Number) {
	var query = "SELECT B_Name FROM rooms WHERE Number='" + Room_Number + "'";
	return new Promise(function(resolve, reject) {
		connection.query(query, function(err, rows, fields) {
			console.log(query);
			if (err) {
				reject("Error in query: " + err);
			} else {
				if (!isNaN(Room_Number) && rows.length > 0) {
					console.log("Building Name: " + rows[0].B_Name)
					resolve(rows[0].B_Name);
				} else {
					console.log("Room number: Not set");
					resolve("Not set");
				}
			}
		});
	});
}

module.exports = router;