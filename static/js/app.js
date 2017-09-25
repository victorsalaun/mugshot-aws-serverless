(function (exports) {

    'use strict';

    const albumBucketName = 'mug-shot-s3';
    const submissionBucketName = 'mug-shot-submission-s3';
    const bucketRegion = 'eu-central-1';
    const IdentityPoolId = 'REPLACE_ME';

    AWS.config.update({
        region: bucketRegion,
        credentials: new AWS.CognitoIdentityCredentials({
            IdentityPoolId: IdentityPoolId
        })
    });

    const mugShotS3 = new AWS.S3({
        apiVersion: '2006-03-01',
        params: {Bucket: albumBucketName}
    });

    const submissionS3 = new AWS.S3({
        apiVersion: '2006-03-01',
        params: {Bucket: submissionBucketName}
    });

    const dynamodb = new AWS.DynamoDB();
    const docClient = new AWS.DynamoDB.DocumentClient();

    exports.app = new Vue({
        // the root element that will be compiled
        el: '.mugsApp',
        // app initial state
        data: {
            mugs: []
        },
        methods: {
            getMugs: function () {
                console.log("hello");
                var vm = this;
                mugShotS3.listObjects(function (err, data) {
                    if (err) {
                        return alert('There was an error viewing your album: ' + err.message);
                    }
                    console.log(data.Contents);
                    vm.mugs = data.Contents;
                });
            },
            addMug: function () {
            }
        },
        mounted: function () {
            this.getMugs();
        }
    });

})(window);