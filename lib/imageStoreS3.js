const AWS = require('aws-sdk')
const s3 = new AWS.S3()

module.exports.save = (name, data) => {
    return new Promise((resolve, reject) => {
        const params = {
            Bucket: 'p-love-nz',
            Key: `pizzas/${name}.png`,
            Body: Buffer.from(data, 'base64'),
            ContentEncoding: 'base64',
            ContentType: 'image/png'
        }

        s3.putObject(params, (err, data) => {
            if (err) {
                reject(err)
            } else {
                resolve(`//p-love-nz.s3.ap-southeast-2.amazonaws.com/${params.Key}`)
            }
        })
    })
}