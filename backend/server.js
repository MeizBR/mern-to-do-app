import express from "express"
import mongoose from "mongoose"
import cors from "cors"
import dotenv from "dotenv"

import userRouter from "./routes/userRoute.js"
import taskRouter from "./routes/taskRoute.js"
import forgotPasswordRouter from "./routes/forgotPassword.js"

//app config
dotenv.config()
const app = express()
const port = 8000
mongoose.set('strictQuery', true);

//middlewares
app.use(express.json())
app.use(cors())

//database connection details
const host = process.env.MONGODB_HOST
const database = process.env.MONGODB_DATABASE
const user = process.env.MONGODB_USER
const password = process.env.MONGODB_PASSWORD

//db config
mongoose.connect(`mongodb+srv://${user}:${password}@${host}/${database}?retryWrites=true&w=majority&appName=Cluster0`, {
    useNewUrlParser: true,
}, (err) => {
    if (err) {
        console.log(err)
    } else {
        console.log("DB Connected")
    }
})

//api endpoints
app.use("/api/user", userRouter)
app.use("/api/task", taskRouter)
app.use("/api/forgotPassword", forgotPasswordRouter)

//listen
app.listen(port, () => console.log(`Listening on ${port}`))