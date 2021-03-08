const AWS = require('aws-sdk')

module.exports.handle = async ({ Records: records }) => {
  try {
    await Promise.all(
      records.map(async (records) => {
        console.log(records)
      }),
    )
    return {
      statusCode: 301,
      body: { status: 'Created' },
    }
  } catch (error) {
    return error
  }
}
