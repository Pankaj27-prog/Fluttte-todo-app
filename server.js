const express = require('express');
const compression = require('compression');
const path = require('path');

const app = express();
const port = process.env.PORT || 3000;

// Enable compression
app.use(compression());

// Serve static files from the build/web directory
app.use(express.static(path.join(__dirname, 'build/web')));

// Handle all routes by serving index.html
app.get('*', (req, res) => {
  res.sendFile(path.join(__dirname, 'build/web/index.html'));
});

app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
}); 