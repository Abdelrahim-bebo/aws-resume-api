const express = require('express');
const app = express();

const dbConfig = {
    host: process.env.DB_HOST || 'localhost (local testing)',
    user: process.env.DB_USER || 'root',
    password: process.env.DB_PASSWORD || 'secret',
    database: process.env.DB_NAME || 'resume_db'
};

const port = process.env.PORT || 8080;

app.get('/', (req, res) => {
    res.json({
        name: "Abdelrahim", //
        nickname: "Bebo", //
        role: "Cloud Engineer & DevOps Professional",
        certifications: ["AWS Cloud Practitioner", "AZ-104", "HCCDA","NUTANIX", "AWS SAA (In Progress)","RHCSA (In Progress)"], //
        skills: ["Docker", "Kubernetes", "Linux", "Git"], //
        database_status: `Configured to connect to RDS at: ${dbConfig.host}` 
    });
});

app.listen(port, () => {
    console.log(`Resume API listening at http://localhost:${port}`);
    console.log(`Environment check: Connecting to DB Host: ${dbConfig.host}`);
});
