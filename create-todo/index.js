// TODO: Add code for creating todos
var AWS = require("aws-sdk");
const { v4: uuidv4 } = require('uuid');
const DynamoDB = new AWS.DynamoDB.DocumentClient();

exports.handler = async(event, context, callback) => {
  const data = JSON.parse(event.body);
  const id = uuidv4();
  let resultStatus;
  try {
    const params = {
      TableName: "todo-table",
      Item: {
        "pk": id,
        "title": data.title,
        "task": data.task
      }
    };
    resultStatus = await DynamoDB.put(params).promise()
      .then(function(data) {
        return {id}
      })
      .catch(function(err) {
        console.log({ err });
        return 400;
      });
  }
  catch (err) {
    resultStatus = 400;
  }
  
  callback(null, {
    statusCode: resultStatus === 400 ? 400 : 200,
    body: JSON.stringify({
      response: resultStatus
    })
  });

};
