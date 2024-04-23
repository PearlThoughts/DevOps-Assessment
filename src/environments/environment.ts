export default () => ({
    port: parseInt(process.env.PORT, 10) || 3000,
    aws: {
      access_key: process.env.AWS_ACCESS_KEY,
      secret_access_key: process.env.AWS_SECRET_ACCESS_KEY,
      region: process.env.AWS_SES_REGION
    },
    nodeEnv: process.env.NODE_ENV || 'development',
  });
  