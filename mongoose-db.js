var mongoose = require('mongoose');
var cfenv = require("cfenv");
var Schema = mongoose.Schema;

var Todo = new Schema({
  content: Buffer,
  updated_at: Date,
});

mongoose.model('Todo', Todo);

var User = new Schema({
  username: String,
  password: String,
});

mongoose.model('User', User);

// CloudFoundry env vars
// var mongoCFUri = cfenv.getAppEnv().getServiceURL('goof-mongo');
// console.log(JSON.stringify(cfenv.getAppEnv()));loudFoundry Mongo URI
// if (mongoCFUri) {
//   mongoUri = mongoCFUri;
// } else if (process.env.MONGOLAB_URI) {
//   // Generic (plus Heroku) env var support
//   mongoUri = process.env.MONGOLAB_URI;
// } else if (process.env.MONGODB_URI) {

//   // Generic (plus Heroku) env var support
//   mongoUri = process.env.MONGODB_URI;
// }

// k8s env setup
// Default Mongo URI is local
mongoUri = process.env.MONGO_URI || 'mongodb://localhost/goof';
console.log("Using Mongo URI " + mongoUri);

mongoose.connect(mongoUri);

User = mongoose.model('User');
User.find({ username: 'admin@snyk.io' }).exec(function (err, users) {
  console.log(users);
  if (users.length === 0) {
    console.log('no admin');
    new User({ username: 'admin@snyk.io', password: process.env.DB_PASS }).save(function (err, user, count) {
      if (err) {
        console.log('error saving admin user');
      }
    });
  }
});