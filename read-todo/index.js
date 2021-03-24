const AWS = require("aws-sdk");
const DynamoDB = new AWS.DynamoDB.DocumentClient();

exports.handler = async function(event, context, callback) {
    console.log(event);
    let resultStatus;
    let resData = "";
    try {
        const params = {
            TableName: "todo-table",
            Key: {
                "pk": event.queryStringParameters.id
            }
        };

        // Call DynamoDB to read the item from the table
        resData = await DynamoDB.get(params).promise()
            .then(function(data) {
                resultStatus = 200;
                return data.Item;
            })
            .catch(function(err) {
                console.log({ err });
                resultStatus = 400;
                return;
            });
    }
    catch (err) {
        resultStatus = 400;
    }

    if (resData) {
        callback(null, {
            statusCode: 200,
            body: JSON.stringify({
                response: resData
            })
        });
    }
    else {
        callback(null, {
            statusCode: 400,
            body: JSON.stringify({
                response: resData
            })
        });
    }

};
