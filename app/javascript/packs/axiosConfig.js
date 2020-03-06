const axios = require('axios')

const instance = axios.create({
  baseURL: `/`,
  timeout: 0,
  headers: {
    'Content-Type': 'application/json'
  }
})

module.exports = instance