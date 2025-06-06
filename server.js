const express = require('express');
const compression = require('compression');
const path = require('path');

const app = express();
const port = process.env.PORT || 3000;

// Enable compression
app.use(compression());

// Set security headers
app.use((req, res, next) => {
  res.setHeader('X-Content-Type-Options', 'nosniff');
  res.setHeader('X-Frame-Options', 'DENY');
  res.setHeader('X-XSS-Protection', '1; mode=block');
  next();
});

// Serve static files from the build/web directory
app.use(express.static(path.join(__dirname, 'build', 'web'), {
  maxAge: '1y',
  etag: true,
  lastModified: true,
}));

// Handle all routes by serving index.html
app.get('*', (req, res) => {
  res.sendFile(path.join(__dirname, 'build', 'web', 'index.html'));
});

// Error handling
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).send('Something broke!');
});

app.listen(port, () => {
  console.log(`Server is running in ${process.env.NODE_ENV} mode on port ${port}`);
  console.log(`App URL: ${process.env.FLUTTER_WEB_APP_URL || 'http://localhost:' + port}`);
  console.log(`Serving files from: ${path.join(__dirname, 'build', 'web')}`);
}); 