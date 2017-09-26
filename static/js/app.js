(function (exports) {

    'use strict';

    const albumBucketName = 'mug-shot-s3';
    const submissionBucketName = 'mug-shot-submission-s3';
    const bucketRegion = 'eu-central-1';
    const IdentityPoolId = 'eu-central-1:35302cfb-0108-4008-b586-435891ae6740';

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
            mugs: [],
            showModal: false
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
            addMug: function (file) {
                submissionS3.upload({
                    Key: file.name,
                    Body: file,
                    ACL: 'public-read'
                }, function (err, data) {
                    if (err) {
                        return alert('There was an error uploading your photo: ' + err.message);
                    }
                });
            }
        },
        mounted: function () {
            this.getMugs();
        }
    });

})(window);

Vue.component('modal', {
    template: '#modal-template',
    props: ['show'],
    methods: {
        close: function () {
            this.$emit('close');
        }
    }
});

Vue.component('NewPostModal', {
    template: '#new-post-modal-template',
    props: ['show'],
    data: function () {
        return {
            title: '',
            body: ''
        };
    },
    methods: {
        close: function () {
            this.$emit('close');
            this.title = '';
            this.body = '';
        },
        savePost: function () {
            // Some save logic goes here...
            this.$parent.addMug(event.target.files[0]);
            this.close();
        }
    }
});