const defaultUrl = "mongodb://localhost:27017/dd_db";

module.exports = {
  url: process.env.MONGO_URI || defaultUrl
};
