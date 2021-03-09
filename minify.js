require('dotenv').config()

const AWS = require('aws-sdk')
const sharp = require('sharp')
const { basename, extname } = require('path')

const S3 = new AWS.S3()

const optionsImage = {
  formatImage: 'jpeg',
  sizeImage: [1280, 720],
}

function keyName(key, formatImage) {
  return `optimize/${basename(key, extname(key))}.${formatImage}`
}

module.exports.handle = async ({ Records: records }) => {
  console.log(`Bucket: ${process.env.S3BUCKET}`)
  try {
    await Promise.all(
      records.map(async (record) => {
        const { key } = record.s3.object

        const image = await S3.getObject({
          Bucket: process.env.S3BUCKET,
          Key: key,
        }).promise()

        console.log(`Image: ${key}`)

        const optimized = await sharp(image.Body)
          .resize(...optionsImage.sizeImage, {
            fit: 'inside',
            withoutEnlargement: true,
          })
          .toFormat(optionsImage.formatImage, {
            progressive: true,
            quality: 50,
          })
          .toBuffer()

        await S3.putObject({
          Body: optimized,
          Bucket: process.env.S3BUCKET,
          ContentType: `image/${optionsImage.formatImage}`,
          Key: keyName(key, optionsImage.formatImage),
        }).promise()

        await S3.deleteObject({
          Bucket: process.env.S3BUCKET,
          Key: key,
        }).promise()
      }),
    )
  } catch (error) {
    return error
  }
}
