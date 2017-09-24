var albumBucketName = 'mug-shot-s3';
var submissionBucketName = 'mug-shot-submission-s3';
var bucketRegion = 'eu-central-1';
var IdentityPoolId = 'REPLACE_ME';

AWS.config.update({
    region: bucketRegion,
    credentials: new AWS.CognitoIdentityCredentials({
        IdentityPoolId: IdentityPoolId
    })
});

var mugShotS3 = new AWS.S3({
    apiVersion: '2006-03-01',
    params: {Bucket: albumBucketName}
});

var submissionS3 = new AWS.S3({
    apiVersion: '2006-03-01',
    params: {Bucket: submissionBucketName}
});

var dynamodb = new AWS.DynamoDB();
var docClient = new AWS.DynamoDB.DocumentClient();

function viewAlbum(albumName) {
    var albumPhotosKey = encodeURIComponent(albumName) + '//';
    mugShotS3.listObjects(function (err, data) {
        if (err) {
            return alert('There was an error viewing your album: ' + err.message);
        }
        // `this` references the AWS.Response instance that represents the response
        var href = this.request.httpRequest.endpoint.href;
        var bucketUrl = href + albumBucketName + '/';

        var photos = data.Contents.map(function (photo) {
            var photoKey = photo.Key;
            var photoUrl = bucketUrl + encodeURIComponent(photoKey);
            return getHtml([
                '<span>',
                '<div>',
                '<img style="width:128px;height:128px;" src="' + photoUrl + '"/>',
                '</div>',
                '<div>',
                '<span onclick="deletePhoto(\'' + albumName + "','" + photoKey + '\')">',
                'X',
                '</span>',
                '<span>',
                photoKey.replace(albumPhotosKey, ''),
                '</span>',
                '</div>',
                '<span>'
            ]);
        });
        var message = photos.length ?
            '<p>Click on the X to delete the photo</p>' :
            '<p>You do not have any photos in this album. Please add photos.</p>';
        var htmlTemplate = [
            '<h2>',
            'Album: ' + albumName,
            '</h2>',
            message,
            '<div>',
            getHtml(photos),
            '</div>',
            '<input id="photoupload" type="file" accept="image/*">',
            '<button id="addphoto" onclick="addPhoto()">',
            'Add Photo',
            '</button>',
            '<button onclick="listAlbums()">',
            'Back To Albums',
            '</button>'
        ];
        document.getElementById('app').innerHTML = getHtml(htmlTemplate);
    });
}

function addPhoto() {
    var files = document.getElementById('photoupload').files;
    if (!files.length) {
        return alert('Please choose a file to upload first.');
    }
    var file = files[0];
    var fileName = file.name;

    submissionS3.upload({
        Key: fileName,
        Body: file,
        ACL: 'public-read'
    }, function (err, data) {
        if (err) {
            return alert('There was an error uploading your photo: ' + err.message);
        }
    });
}

function listMovies() {
    var params = {};
    dynamodb.listTables(params, function (err, data) {
        if (err) {
            console.error("Unable to list tables: " + "\n" + JSON.stringify(err, undefined, 2));
        }
        else {
            console.log(JSON.stringify(data, undefined, 2));
        }
    });
}