const express = require("express");

const app = express();
const PORT = 8080;

app.get("/api/hello", (req, res) => {
    res.json({
        message: "Hello from CloudDeploy Backend!",
        status: "success"
    });
});

app.get("/api/health", (req, res) => {
    res.json({
        status: "UP"
    });
});

app.listen(PORT, "0.0.0.0", () => {
    console.log(`Backend running on port ${PORT}`);
});
