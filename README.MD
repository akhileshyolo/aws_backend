<!-- Documentation goes here -->

# Introduction

- Please install nodejs bestzip module
```
npm install -g bestzip
```

Ensure you have AWS IAM role configured on your machine.

1. Create New Bucket to store lambda zip files
```
npm run setup-bucket ${BUCKETNAME}
```

2. To Deploy all resources API, Lambda, DynamoDB
```
npm run deploy ${BUCKETNAME}
```

3. To Test
```
npm run test
```